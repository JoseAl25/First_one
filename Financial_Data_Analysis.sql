--Entidad X Crecimiento interanual de cartera

with base as (

SELECT PERIODO_ID,
SUM(CASE WHEN Columna_1 in
(14010302000000,
14040302000000,
14050302000000,
14050319020000,
14060302000000,
14060319020000,
14010306030000,
14040306030000,
14050306030000,
14050319060000,
14060306030000,
14060319060000
)

THEN Columna_2 ELSE 0 END) DISEF,

SUM(CASE WHEN Columna_1 in
(14010302000000,
14040302000000,
14050302000000,
14050319020000,
14060302000000,
14060319020000,
14010306030000,
14040306030000,
14050306030000,
14050319060000,
14060306030000,
14060319060000

) and Columna_3 = 2

THEN Columna_2 ELSE 0 END) interbank_1,

SUM(CASE WHEN Columna_1 in
(14010302000000,
14040302000000,
14050302000000,
14050319020000,
14060302000000,
14060319020000,
14010306030000,
14040306030000,
14050306030000,
14050319060000,
14060306030000,
14060319060000

) and Columna_3 = 1
THEN Columna_2 ELSE 0 END) BCP,

SUM(CASE WHEN Columna_1 in
(14010302000000,
14040302000000,
14050302000000,
14050319020000,
14060302000000,
14060319020000,
14010306030000,
14040306030000,
14050306030000,
14050319060000,
14060306030000,
14060319060000

) and Columna_3 = 73

THEN Columna_2 ELSE 0 END) Ripley,
SUM(CASE WHEN Columna_1 in
(14010302000000,
14040302000000,
14050302000000,
14050319020000,
14060302000000,
14060319020000,
14010306030000,
14040306030000,
14050306030000,
14050319060000,
14060306030000,
14060319060000
) and Columna_3 = 142

THEN Columna_2 ELSE 0 END) Falabella,

SUM(CASE WHEN Columna_1 in
(14010302000000,
14040302000000,
14050302000000,
14050319020000,
14060302000000,
14060319020000,
14010306030000,
14040306030000,
14050306030000,
14050319060000,
14060306030000,
14060319060000
) and Columna_2 = 72

THEN Columna_3 ELSE 0 END) Credicotia
FROM VW_BALANCE
WHERE PERIODO_ID >= 20160731
and Columna_1 in(
14010302000000,
14040302000000,
14050302000000,
14050319020000,
14060302000000,
14060319020000,
14010306030000,
14040306030000,
14050306030000,
14050319060000,
14060306030000,
14060319060000
)

GROUP BY PERIODO_ID

Select periodo_id, DISEF, interbank_1, BCP,Ripley, Falabella, Credicotia,
(DISEF / lag(DISEF,12) over (order by periodo_id) )-1 as SISTEMA,
(interbank_1 / lag(interbank_1,12) over (order by periodo_id) )-1 as INTERBANK,
(BCP / lag(BCP,12) over (order by periodo_id) )-1 as "BANCO DE CREDITO",
(Ripley / lag(Ripley,12) over (order by periodo_id) )-1 as "BANCO RIPLEY",
(Falabella / lag(Falabella,12) over (order by periodo_id) )-1 as "BANCO FALABELLA",
(Credicotia / lag(Credicotia,12) over (order by periodo_id) )-1 as CREDISCOTIA
from base
order by periodo_id DESC;

--Banca no minorista, concentración 10 principales clientes:

Select periodo_id, Columna_1,Columna_2,
sum(Columna_3) as Cartera_total,
sum(sum(Columna_3)) over (partition by periodo_id) as Total_cartera_periodo
from abc_base
where Columna_4 = 22
and Columna_5 <= 18
and Columna_6 in (1401,1403,1404,1403,1405,1406,7101,7102,7103,7104)
and periodo_id >= 20210731
group by periodo_id, Columna_2,Columna_3
order by 1 desc, 4 desc

--Deuda Directa:

Select periodo_id, Columna_2,Columna_3,
sum(Columna_4) as Cartera_total,
sum(sum(Columna_4)) over (partition by periodo_id) as Total_cartera_periodo
from abc_base
where Columna_4 = 22
and Columna_5 <= 18
and Columna_6 in (1401,1403,1404,1403,1405,1406)
and periodo_id >= 20210731
group by periodo_id, Columna_2,Columna_3
order by 1 desc, 4 desc

 
--gráfico de ROA, ROE con la info de Balance

with base as (
Select periodo_fecha, Columna_2, Columna_3,
sum(case when Columna_4 in
(10000000000000) and Columna_5 = 22 then Columna_6 else 0 end)/1000 as Activo_Total_Comercio,
sum(case when Columna_4 in
(30000000000000) then Columna_5 else 0 end)/1000 as Patrimonio_Total,
sum(case when Columna_4 in
(69000000000000) then Columna_2 else 0 end)/1000 as Utilidad_Neta,
lag(sum(case when Columna_4 in(69000000000000) then Columna_2 else 0 end),12)
over (order by Columna_3,periodo_fecha)/1000 as "Utilidad(t-12)",
lag(sum(case when Columna_4 in(69000000000000) then Columna_2 else 0 end),
Extract (month from periodo_fecha)) over (order by Columna_3,periodo_fecha)/1000 as "Utilidad_fin_ejercicio",
sum(case when Columna_4 in (69000000000000) then Columna_2 else 0 end)/1000 -
lag(sum(case when Columna_4 in(69000000000000) then Columna_2 else 0 end),12)
over (order by Columna_3,periodo_fecha)/1000  +
lag(sum(case when Columna_4 in(69000000000000) then Columna_2 else 0 end),
Extract (month from periodo_fecha)) over (order by Columna_3,periodo_fecha)/1000 as "Utilidad Anualizada"

from VW_ABC_ABC_SF
where Columna_3 in  (22,82,55,126)
and periodo_id >= 20171231
group by periodo_fecha,Columna_3, Columna_4
order by 2 DESC,1 desc
)

Select periodo_fecha,sum(case when periodo_fecha >= '30/09/20' then Activo_Total else 0 end)/12 as Activo_Promedio
from base
group by periodo_fecha
order by periodo_fecha DESC;

 


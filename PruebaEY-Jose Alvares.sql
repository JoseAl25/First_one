

--1 Identificar qué clientes del listado de transacciones no se encuentran en el maestro de clientes.

Select distinct lis.[Codigo de Cliente], ma.[Codigo de Cliente] 

from Listado_Transacciones_31122020 lis  left join Maestro_Clientes_31122020 ma on lis.[Codigo de Cliente] =  ma.[Codigo de Cliente]
where ma.[Codigo de Cliente] is null

-- 2 Identificar el monto total por cada tipo de transacción de las partidas abiertas (que no hayan sido pagadas) al 31.12.2020.

Select lis.[Tipo de Transaccion], sum(lis.monto) as Monto from Listado_Transacciones_31122020 lis
where lis.[Fecha de Pago] = ''
group by lis.[Tipo de Transaccion]

--3 - Por las partidas cerradas, indique por favor el nombre de los 4 clientes que se demoran más en --pagar. Nota: Haga esta evaluación con el promedio de pagos.Select top 4 with ties lis.[Codigo de Cliente],ma.[Nombre de Cliente] , lis.[Fecha de Documento], lis.[Fecha de Pago] ,avg(lis.monto) as monto_promedio,
DATEDIFF(day,lis.[Fecha de Documento],lis.[Fecha de Pago]) as Dias_Entre_Pago
from Listado_Transacciones_31122020 lis left join Maestro_Clientes_31122020 ma on lis.[Codigo de Cliente] = ma.[Codigo de Cliente]
where lis.[Fecha de Pago] <>''
group by lis.[Codigo de Cliente], lis.[Fecha de Documento], lis.[Fecha de Pago],ma.[Nombre de Cliente] 
order by Dias_Entre_Pago DESC

--4 Identificar si el total de transacciones, de partidas abiertas, por libro mayor (Subledger Name) es
--equivalente al saldo de la cuenta del balance de comprobación (diciembre 2020).

with base as (
Select  lis.[Libro Mayor], sum(lis.Monto) as monto from Listado_Transacciones_31122020 lis
where lis.[Fecha de Pago] = ''
group by lis.[Libro Mayor] ) 

Select base.[Libro Mayor],sum(base.monto) Monto_Transacc, sum(tb.MontoFinal) as Monto_BC
from base left join TB_01012020_31122020 tb on base.[Libro Mayor] = tb.CuentaContable
group by base.[Libro Mayor]


--5 Identificar si cada asiento de diario (identificado a través del Código de JE) tiene por suma monto 0.

Select je.JENumber, sum(je.Monto) as Monto
from JE_01012020_31122020 je 
group by je.JENumber
having sum(je.Monto) <> 0;



--6 Prueba Integridad:
with base as(
Select  je.CuentaContable ,sum(monto) as Suma_periodo from JE_01012020_31122020 je
group by je.CuentaContable)

Select tb.CuentaContable as CuentaContable,tb.MontoInicial,
isnull(b.Suma_periodo,0) as Suma_periodo,tb.MontoFinal,tb.MontoInicial+isnull(b.Suma_periodo,0)-tb.MontoFinal as Comprobacion

from TB_01012020_31122020 tb left join base b on tb.CuentaContable=b.cuentacontable
--where tb.MontoInicial+isnull(b.Suma_periodo,0)-tb.MontoFinal <> 0

Select je.JENumber, sum(je.Monto) as monto from JE_01012020_31122020 je
group by je.JENumber
having sum(je.Monto) <> 0

Select * from JE_01012020_31122020 je

--Ver los gastos mensuales según categoría de gasto
Select distinct(cast(month(je.FechaEfectiva) as varchar)) +'/'+ cast(year(je.FechaEfectiva) as varchar)
as fecha,coa.CuentaContable_Clase,sum(je.Monto) as monto from COA_31122020 coa inner join JE_01012020_31122020 je on
coa.CuentaContable = je.CuentaContable
group by 
cast(month(je.FechaEfectiva) as varchar) +'/'+ cast(year(je.FechaEfectiva) as varchar),
coa.CuentaContable_Clase
order by 1 desc, 3 DESC


--Para ver si funciona el código de conversión de fecha
Select distinct(cast(month(je.FechaEfectiva) as varchar)) +'/'+ cast(year(je.FechaEfectiva) as varchar) 
from JE_01012020_31122020 je

where coa.CuentaContable_Clase in ('",Cost of sales',
'"Intangible, net"',
'"Property, plant and equipment, net"',
'"Trade accounts receivable, net"')


--Verificando cuentas con descripción diferente
select  coa.CuentaContable_Clase from COA_31122020 coa

select  * from COA_31122020 coa

",Cost of sales
"Intangible, net"
"Property, plant and equipment, net"
"Trade accounts receivable, net"
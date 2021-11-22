

--Ver los gastos mensuales según categoría de gasto
Select distinct(cast(month(je.FechaEfectiva) as varchar)) +'/'+ cast(year(je.FechaEfectiva) as varchar)
as fecha,coa.CuentaContable_Clase,sum(je.Monto) as monto from COA_31122020 coa inner join JE_01012020_31122020 je on
coa.CuentaContable = je.CuentaContable
group by 
cast(month(je.FechaEfectiva) as varchar) +'/'+ cast(year(je.FechaEfectiva) as varchar),
coa.CuentaContable_Clase
order by 1 desc, 3 DESC



--Verificando cuentas con descripción diferente
select  coa.CuentaContable_Clase from COA_31122020 coa


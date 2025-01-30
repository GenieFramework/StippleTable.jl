using Test
using StippleTable

@test Base.pkgversion(StippleTable) ≥ v"1.0.4"
@test contains(sttable(:table, :event, param = :param, "inner"), ">inner<")
@test contains(sttable(:table, :event, param = :param, "inner1", ["inner"]), ">inner1inner<")
using Test
using StippleTable

@test contains(sttable(:table, :event, param = :param, "inner"), ">inner<")
@test contains(sttable(:table, :event, param = :param, "inner1", ["inner"]), ">inner1inner<")
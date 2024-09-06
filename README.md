# StippleTable

This component enhances the Table component from StippleUI with support for for server-side pagination and filtering.

## Installation

To install the most recent released version of package:

```
pkg> add StippleTable
```
 
## Usage



Create a simple `app.jl` script
```julia

module App

using GenieFramework
using DataFrames
using StippleTable
@genietools

StippleUI.Tables.set_default_rows_per_page(20)
StippleUI.Tables.set_max_rows_client_side(11_000)

const big_data = sort!(DataFrame(rand(1_000_000, 2), ["x1", "x2"]))::DataFrame

@app begin
  @out dt1 = DataTable(big_data; server_side = true)
  @out loading = false
  @out dt2 = DataTable(big_data)
end

@event dt1_request begin
  loading = true
  dt1 = @paginate(dt1, big_data)
  @push
  loading = false
end

ui() = """
<st-table 
    :loading="loading"  
    :data_table="dt1"
    server_side_event="dt1_request"
    :dense="true" 
 />
"""

@page("/", ui)

end

```


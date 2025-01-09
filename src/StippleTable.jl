module StippleTable

using Stipple, StippleUI.API

export sttable

const assets_config = Genie.Assets.AssetsConfig(package="StippleTable.jl")

import Stipple.Genie.Renderer.Html: register_normal_element, normal_element

register_normal_element("st__table", context=@__MODULE__)



function sttable(data::Symbol;kwargs...)
    st__table(;kw([:data_table => data, kwargs...])...)
end

"""
    sttable(data::Symbol, event::Symbol; kwargs...)

An enhanced `table` component with server-side pagination and filtering. 
The `event` is fired by the UI when the user interacts with the pagination controls.

### Example

```julia
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

ui() = sttable(:dt1, :dt1_request)
```
"""
function sttable(data::Symbol, event::Symbol;kwargs...)
    st__table(;kw([:data_table => data, :server_side_event => event, kwargs...])...)
end

function gb_component_routes()
    package_subpath_part = "stippletable" # change these, keep the other parts as defined below

    # don't change these
    # GenieDevTools identifies the components by their asset path, which must be of the form /components/stipplemarkdown/gb_component/
    prefix = "components"
    gb_component_path = "gb_component"
    assets_folder_path = "$package_subpath_part/$gb_component_path"
    icons_folder_path = "icons"

    [
    Genie.Router.route(Genie.Assets.asset_route(
        assets_config,
        "", # type
        file="definitions.json",
        path=assets_folder_path,
        prefix=prefix,
        ext=""
    ),
    named=:get_gb_component_stippletable_definitionsjson) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(
                Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")),
                file="definitions.json",
                path=gb_component_path,
                type="")
            ),
            :json) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(
        assets_config,
        "", # type
        file="canvas.css",
        path=assets_folder_path,
        prefix=prefix,
        ext=""
    ),
    named=:get_gb_component_stippletable_canvascss) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(
                Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")),
                file="canvas.css",
                path=gb_component_path,
                type="")
            ),
            :css) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(
        assets_config,
        "", # type
        file="sttable.png",
        path="$assets_folder_path/$icons_folder_path",
        prefix=prefix,
        ext=""
    ),
    named=:get_gb_component_stippletable_icons_sttablepng) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(
                Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")),
                file="sttable.png",
                path=joinpath(gb_component_path, icons_folder_path),
                type="")
            ),
            :png) |> Genie.Renderer.respond
    end
    ]
end

function deps_routes()
    haskey(ENV, "GB_JULIA_PATH") && gb_component_routes()

    Genie.Assets.external_assets(Stipple.assets_config) && return nothing

    Genie.Router.route(Genie.Assets.asset_route(assets_config, :js, file="stippletable"), named=:get_stippletablejs) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")), file="stippletable.js")),
            :javascript) |> Genie.Renderer.respond
    end


    nothing
end

function deps()
    [
        Genie.Renderer.Html.script(src=Genie.Assets.asset_path(assets_config, :js, file="stippletable")),
    ]
end

function __init__()
    deps_routes()
    Stipple.deps!(@__MODULE__, deps)
end

end

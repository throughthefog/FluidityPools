function itemHelper()
    while true do
        if FluidityPools.config.dynamicPricing then
            for k,v in pairs(FluidityPools.items) do
                for kk,vv in ipairs(v) do
                    local count = FluidityPools.BIL.getItemCount(vv.query)
                    if vv.forcePrice then
                        FluidityPools.items[k][kk].price = vv.normalPrice
                        FluidityPools.items[k][kk].count = count
                    else
                        if count == 0 then
                            FluidityPools.items[k][kk].price = vv.normalPrice
                        else
                            FluidityPools.items[k][kk].price = (vv.normalStock/count)*vv.normalPrice
                        end
                        FluidityPools.items[k][kk].count = count
                    end
                end
            end
        else
            for k,v in pairs(FluidityPools.items) do
                for kk,vv in ipairs(v) do
                    FluidityPools.items[k][kk].price = vv.normalPrice
                    FluidityPools.items[k][kk].count = FluidityPools.BIL.getItemCount(vv.query)
                end
            end
        end
        FluidityPools.pricesLoaded = true
        FluidityPools.countsLoaded = true
        os.sleep(0)
    end
end

return itemHelper
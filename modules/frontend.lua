local monitor = nil
local config = nil
local items = nil
local bigfont = nil
local BIL = nil
local loggedIn = nil
local w,h = 0

local selectedCategory = ""

function renderInit()
    monitor.setTextScale(0.5)
    monitor.setBackgroundColor(config.palette.content.bg)
    monitor.setTextColor(config.palette.content.fg)
    monitor.clear()

    monitor.setBackgroundColor(config.palette.header.bg)
    monitor.setTextColor(config.palette.header.fg)
    monitor.setCursorPos(1,1)
    monitor.clearLine()
    monitor.setCursorPos(1,2)
    monitor.clearLine()
    monitor.setCursorPos(1,3)
    monitor.clearLine()
    monitor.setCursorPos(1,4)
    monitor.clearLine()

    monitor.setBackgroundColor(config.palette.footer.bg)
    monitor.setTextColor(config.palette.footer.fg)
    monitor.setCursorPos(1,h-3)
    monitor.clearLine()
    monitor.setCursorPos(1,h-2)
    monitor.clearLine()
    monitor.setCursorPos(1,h-1)
    monitor.clearLine()
    monitor.setCursorPos(1,h)
    monitor.clearLine()

    monitor.setBackgroundColor(config.palette.header.bg)
    monitor.setTextColor(config.palette.header.fg)
    monitor.setCursorPos(w/2-#config.description/2,1)
    monitor.write(config.description)
    bigfont.writeOn(monitor, 1, config.shopname, w/2-(#config.shopname*3)/2,2)

    monitor.setTextColor(config.palette.logo.fg)
    monitor.setCursorPos(w-#("FluidityPools")+1, 1)
    monitor.write("FluidityPools")

    monitor.setBackgroundColor(config.palette.footer.bg)
    monitor.setTextColor(config.palette.footer.fg)
    if loggedIn.is then
        bigfont.writeOn(monitor, 1, "bal: \164"..tostring(math.floor(loggedIn.balance*1000)/1000), 2,h-2)
        monitor.setCursorPos(w-#(loggedIn.username.." exit with \\"..config.command.." exit")-1, h-2)
        monitor.write(loggedIn.username.." ")
        monitor.setTextColor(config.palette.footer.exitfg)
        monitor.write("exit with \\"..config.command.." exit")
        monitor.setCursorPos(w-#("deposit at "..(config.kristName ~= nil and (config.kristName..".kst") or config.address))-1,h-1)
        monitor.write("deposit at "..(config.kristName ~= nil and (config.kristName..".kst") or config.address))
    else
        bigfont.writeOn(monitor, 1, "start with \\"..config.command.." start", 2,h-2)
    end
    renderCategories()
    renderBanners()
    renderItems()
end

function renderCategories()
    monitor.setBackgroundColor(config.palette.footer.bg)
    monitor.setTextColor(config.palette.footer.fg)
    monitor.setCursorPos(1,h-4)
    monitor.clearLine()
    local x = 2
    for k,v in pairs(items) do
        if k == selectedCategory then
            monitor.setBackgroundColor(config.palette.content.bg)
            monitor.setTextColor(config.palette.content.fg)
        else
            monitor.setBackgroundColor(config.palette.footer.bg)
            monitor.setTextColor(config.palette.footer.fg)
        end
        monitor.setCursorPos(x-1,h-4)
        monitor.write(" "..k.." ")
        x = x + #k + 2
    end
end

function renderBanners()
    if config.mode == "both" then
        local mid = w/2
        for y=5,5+4 do
            for x=1,mid do
                monitor.setBackgroundColor(config.palette.buy.bg)
                monitor.setCursorPos(x,y)
                monitor.write(" ")
            end
            for x=mid+1,w+1 do
                monitor.setBackgroundColor(config.palette.sell.bg)
                monitor.setCursorPos(x,y)
                monitor.write(" ")
            end
        end

        monitor.setBackgroundColor(config.palette.buy.bg)
        monitor.setTextColor(config.palette.buy.fg)
        bigfont.writeOn(monitor, 1, "buy", mid/2-(#("Buy")*3)/2, 6)
        monitor.setCursorPos(mid/2-#("\\"..config.command.." buy <item> <amount>")/2, 5+4)
        monitor.write("\\"..config.command.." buy <item> <amount>")
        monitor.setBackgroundColor(config.palette.sell.bg)
        monitor.setTextColor(config.palette.sell.fg)
        bigfont.writeOn(monitor, 1, "sell", (mid/2-(#("Sell")*3)/2)+mid, 6)
        monitor.setCursorPos((mid/2-#("drop above the turtle")/2)+mid, 5+4)
        monitor.write("drop above the turtle")
        renderColumns()
    elseif config.mode == "buy" then
        for y=5,5+4 do
            for x=1,w do
                monitor.setBackgroundColor(config.palette.buy.bg)
                monitor.setCursorPos(x,y)
                monitor.write(" ")
            end
        end

        monitor.setBackgroundColor(config.palette.buy.bg)
        monitor.setTextColor(config.palette.buy.fg)
        bigfont.writeOn(monitor, 1, "buy", w/2-(#("Buy")*3)/2, 6)
        monitor.setCursorPos(w/2-#("\\"..config.command.." buy <item> <amount>")/2, 5+4)
        monitor.write("\\"..config.command.." buy <item> <amount>")
        renderColumns()
    elseif config.mode == "sell" then
        for y=5,5+4 do
            for x=1,w do
                monitor.setBackgroundColor(config.palette.sell.bg)
                monitor.setCursorPos(x,y)
                monitor.write(" ")
            end
        end

        monitor.setBackgroundColor(config.palette.sell.bg)
        monitor.setTextColor(config.palette.sell.fg)
        bigfont.writeOn(monitor, 1, "sell", w/2-(#("Sell")*3)/2, 6)
        monitor.setCursorPos(w/2-#("drop above the turtle")/2, 5+4)
        monitor.write("drop above the turtle")
        renderColumns()
    else
        bsod("Invalid config for mode!")
    end
end

function renderColumns()
    if config.mode == "both" then
        local mid = w/2
        monitor.setBackgroundColor(config.palette.column.bg)
        monitor.setTextColor(config.palette.column.fg)
        monitor.setCursorPos(1, 5+4+1)
        monitor.clearLine()
        monitor.setCursorPos(w/2-#("Item")/2+1, 5+4+1)
        monitor.write("Item")

        monitor.setCursorPos(mid/2/2-#("x64")/2, 5+4+1)
        monitor.write("x64")
        monitor.setCursorPos(mid/2-#("x8")/2, 5+4+1)
        monitor.write("x8")
        monitor.setCursorPos((mid/2/2-#("x1")/2)+mid/2, 5+4+1)
        monitor.write("x1")

        monitor.setCursorPos((mid/2/2-#("x1")/2)+mid, 5+4+1)
        monitor.write("x1")
        monitor.setCursorPos((mid/2-#("x8")/2)+mid, 5+4+1)
        monitor.write("x8")
        monitor.setCursorPos(((mid/2/2-#("x64")/2)+mid/2)+mid, 5+4+1)
        monitor.write("x64")
    elseif config.mode == "buy" then
        monitor.setBackgroundColor(config.palette.column.bg)
        monitor.setTextColor(config.palette.column.fg)
        monitor.setCursorPos(1, 5+4+1)
        monitor.clearLine()
        monitor.setCursorPos(w-#("Item")+1, 5+4+1)
        monitor.write("Item")
        
        monitor.setCursorPos(w/2/2/2-#("x4096")/2, 5+4+1)
        monitor.write("x4096")
        monitor.setCursorPos((w/2/2/2-#("x512")/2)+w/2/2/2, 5+4+1)
        monitor.write("x512")
        monitor.setCursorPos((w/2/2-#("x128")/2)+w/2/2/2, 5+4+1)
        monitor.write("x128")
        monitor.setCursorPos(w/2-#("x64")/2, 5+4+1)
        monitor.write("x64")
        monitor.setCursorPos((w/2/2/2-#("x32")/2)+w/2, 5+4+1)
        monitor.write("x32")
        monitor.setCursorPos((w/2/2-#("x8")/2)+w/2, 5+4+1)
        monitor.write("x8")
        monitor.setCursorPos((w/2/2-#("x1")/2)+w/2/2/2+w/2, 5+4+1)
        monitor.write("x1")
    elseif config.mode == "sell" then
        monitor.setBackgroundColor(config.palette.column.bg)
        monitor.setTextColor(config.palette.column.fg)
        monitor.setCursorPos(1, 5+4+1)
        monitor.clearLine()
        monitor.setCursorPos(1, 5+4+1)
        monitor.write("Item")

        monitor.setCursorPos(w/2/2/2-#("x1")/2, 5+4+1)
        monitor.write("x1")
        monitor.setCursorPos((w/2/2/2-#("x8")/2)+w/2/2/2, 5+4+1)
        monitor.write("x8")
        monitor.setCursorPos((w/2/2-#("x32")/2)+w/2/2/2, 5+4+1)
        monitor.write("x32")
        monitor.setCursorPos(w/2-#("x64")/2, 5+4+1)
        monitor.write("x64")
        monitor.setCursorPos((w/2/2/2-#("x128")/2)+w/2, 5+4+1)
        monitor.write("x128")
        monitor.setCursorPos((w/2/2-#("x512")/2)+w/2, 5+4+1)
        monitor.write("x512")
        monitor.setCursorPos((w/2/2-#("x4096")/2)+w/2/2/2+w/2, 5+4+1)
        monitor.write("x4096")
    end
end

local function computeDP(item, count, sell)
    if sell then
        local mprice = item.normalPrice
        mprice = mprice - (mprice * (config.tradingFees/100))
        if config.dynamicPricing and (not item.forcePrice) then
            if item.count == 0 then
                return mprice * count
            else
                return (item.normalStock/(item.count+count))*mprice*count
            end
        else
            return mprice * count
        end
    else
        local mprice = item.normalPrice
        mprice = mprice + (mprice * (config.tradingFees/100))
        if config.dynamicPricing or item.forcePrice then
            if item.count == 0 then
                return mprice * count
            elseif item.count-count < 0 then
                return math.huge
            else
                return (item.normalStock/(item.count-count+1))*mprice*count
            end
        else
            return mprice * count
        end
    end
end

function renderItems()
    monitor.setBackgroundColor(config.palette.content.bg)
    monitor.setTextColor(config.palette.content.fg)
    for y=5+4+2,h-5 do
        monitor.setCursorPos(1,y)
        monitor.clearLine()
    end
    local y = 5+4+2
    local second = false
    for kk,vv in ipairs(items[selectedCategory]) do
        if second then
            monitor.setBackgroundColor(config.palette.listB.bg)
            second = false
        else
            monitor.setBackgroundColor(config.palette.listA.bg)
            second = true
        end
        if FluidityPools.itemChangeInfo.is and (FluidityPools.itemChangeInfo.category == selectedCategory) and (FluidityPools.itemChangeInfo.pos == kk) then
            if FluidityPools.itemChangeInfo.mode == "buy" then
                monitor.setBackgroundColor(config.palette.buy.bg)
            elseif FluidityPools.itemChangeInfo.mode == "sell" then
                monitor.setBackgroundColor(config.palette.sell.bg)
            end
        end
        monitor.setCursorPos(1,y)
        monitor.clearLine()
        monitor.setCursorPos(1,y+1)
        monitor.clearLine()
        if config.mode == "both" then
            monitor.setTextColor(config.palette.listB.itemfg)
            monitor.setCursorPos(w/2-#vv.name/2+1,y)
            monitor.write(vv.name)
            monitor.setTextColor(config.palette.listB.pricefg)
            monitor.setCursorPos(w/2-#("\164"..tostring(math.floor(vv.price*1000)/1000))/2+1,y+1)
            monitor.write("\164"..tostring(math.floor(vv.price*1000)/1000))
            --BUYING
            monitor.setCursorPos((w/2/2/2+#("x64")/2)-#("\164"..tostring(math.floor(computeDP(vv,64)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,64)*1000)/1000))
            monitor.setCursorPos((w/2/2/2+#("x64")/2)-#("\164"..tostring(math.floor(computeDP(vv,64)/64*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,64)/64*1000)/1000).."/i")

            monitor.setCursorPos((w/2/2+#("x8")/2)-#("\164"..tostring(math.floor(computeDP(vv,8)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,8)*1000)/1000))
            monitor.setCursorPos((w/2/2+#("x8")/2)-#("\164"..tostring(math.floor(computeDP(vv,8)/8*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,8)/8*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2/2+#("x1")/2)+w/2/2)-#("\164"..tostring(math.floor(computeDP(vv,1)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,1)*1000)/1000))
            monitor.setCursorPos(((w/2/2/2+#("x1")/2)+w/2/2)-#("\164"..tostring(math.floor(computeDP(vv,1)*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,1)*1000)/1000).."/i")
            --SELLING
            monitor.setCursorPos(((w/2/2/2-#("x1")/2)+w/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,1,true)*1000)/1000))
            monitor.setCursorPos(((w/2/2/2-#("x1")/2)+w/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,1,true)*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2-#("x8")/2)+w/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,8,true)*1000)/1000))
            monitor.setCursorPos(((w/2/2-#("x8")/2)+w/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,8,true)/8*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2/2-#("x64")/2)+w/2/2+w/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,64,true)*1000)/1000))
            monitor.setCursorPos(((w/2/2/2-#("x64")/2)+w/2/2+w/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,64,true)/64*1000)/1000).."/i")
        elseif config.mode == "buy" then
            monitor.setTextColor(config.palette.listB.itemfg)
            monitor.setCursorPos(w-#vv.name+1,y)
            monitor.write(vv.name)
            monitor.setTextColor(config.palette.listB.pricefg)
            monitor.setCursorPos(w-#("\164"..tostring(math.floor(vv.price*1000)/1000))+1,y+1)
            monitor.write("\164"..tostring(math.floor(vv.price*1000)/1000))

            monitor.setCursorPos((w/2/2/2+#("x4096")/2)-#("\164"..tostring(math.floor(computeDP(vv,4096)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,4096)*1000)/1000))
            monitor.setCursorPos((w/2/2/2+#("x4096")/2)-#("\164"..tostring(math.floor(computeDP(vv,4096)/4096*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,4096)/4096*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2/2+#("x512")/2)+w/2/2/2)-#("\164"..tostring(math.floor(computeDP(vv,512)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,512)*1000)/1000))
            monitor.setCursorPos(((w/2/2/2+#("x512")/2)+w/2/2/2)-#("\164"..tostring(math.floor(computeDP(vv,512)/512*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,512)/512*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2+#("x128")/2)+w/2/2/2)-#("\164"..tostring(math.floor(computeDP(vv,128)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,128)*1000)/1000))
            monitor.setCursorPos(((w/2/2+#("x128")/2)+w/2/2/2)-#("\164"..tostring(math.floor(computeDP(vv,128)/128*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,128)/128*1000)/1000).."/i")

            monitor.setCursorPos((w/2+#("x64")/2)-#("\164"..tostring(math.floor(computeDP(vv,64)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,64)*1000)/1000))
            monitor.setCursorPos((w/2+#("x64")/2)-#("\164"..tostring(math.floor(computeDP(vv,64)/64*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,64)/64*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2/2+#("x32")/2)+w/2)-#("\164"..tostring(math.floor(computeDP(vv,32)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,32)*1000)/1000))
            monitor.setCursorPos(((w/2/2/2+#("x32")/2)+w/2)-#("\164"..tostring(math.floor(computeDP(vv,32)/32*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,32)/32*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2+#("x8")/2)+w/2)-#("\164"..tostring(math.floor(computeDP(vv,8)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,8)*1000)/1000))
            monitor.setCursorPos(((w/2/2+#("x8")/2)+w/2)-#("\164"..tostring(math.floor(computeDP(vv,8)/8*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,8)/8*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2+#("x1")/2)+w/2/2/2+w/2)-#("\164"..tostring(math.floor(computeDP(vv,1)*1000)/1000)),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,1)*1000)/1000))
            monitor.setCursorPos(((w/2/2+#("x1")/2)+w/2/2/2+w/2)-#("\164"..tostring(math.floor(computeDP(vv,1)*1000)/1000).."/i"),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,1)*1000)/1000).."/i")
        elseif config.mode == "sell" then
            monitor.setTextColor(config.palette.listB.itemfg)
            monitor.setCursorPos(1,y)
            monitor.write(vv.name)
            monitor.setTextColor(config.palette.listB.pricefg)
            monitor.setCursorPos(1,y+1)
            monitor.write("\164"..tostring(math.floor(vv.price*1000)/1000))

            monitor.setCursorPos((w/2/2/2-#("x1")/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,1,true)*1000)/1000))
            monitor.setCursorPos((w/2/2/2-#("x1")/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,1,true)*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2/2-#("x8")/2)+w/2/2/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,8,true)*1000)/1000))
            monitor.setCursorPos(((w/2/2/2-#("x8")/2)+w/2/2/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,8,true)/8*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2-#("x32")/2)+w/2/2/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,32,true)*1000)/1000))
            monitor.setCursorPos(((w/2/2-#("x32")/2)+w/2/2/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,32,true)/32*1000)/1000).."/i")

            monitor.setCursorPos((w/2-#("x64")/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,64,true)*1000)/1000))
            monitor.setCursorPos((w/2-#("x64")/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,64,true)/64*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2/2-#("x128")/2)+w/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,128,true)*1000)/1000))
            monitor.setCursorPos(((w/2/2/2-#("x128")/2)+w/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,128,true)/32*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2-#("x512")/2)+w/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,512,true)*1000)/1000))
            monitor.setCursorPos(((w/2/2-#("x512")/2)+w/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,512,true)/512*1000)/1000).."/i")

            monitor.setCursorPos(((w/2/2-#("x4096")/2)+w/2/2/2+w/2),y)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,4096,true)*1000)/1000))
            monitor.setCursorPos(((w/2/2-#("x4096")/2)+w/2/2/2+w/2),y+1)
            monitor.write("\164"..tostring(math.floor(computeDP(vv,4096,true)/4096*1000)/1000).."/i")
        end
        y = y + 2
    end
end

function rerender()
    renderInit()
end

function frontend()
    monitor = FluidityPools.monitor.wrap
    config = FluidityPools.config
    items = FluidityPools.items
    bigfont = FluidityPools.bigfont
    BIL = FluidityPools.BIL
    loggedIn = FluidityPools.loggedIn
    for k,v in pairs(items) do
        selectedCategory = k
        break
    end
    w,h = monitor.getSize()
    monitor.setCursorPos(1,1)
    monitor.write("Loading...")
    while (not FluidityPools.pricesLoaded) or (not FluidityPools.countsLoaded) do
        os.sleep(0)
    end
    monitor.setCursorPos(1,1)
    monitor.clearLine()
    monitor.write("Connecting...")
    while not FluidityPools.kristConnected do
        os.sleep(0)
    end
    rerender()
    local function categoryClicker()
        while true do
            local event, side, x, y = os.pullEvent("monitor_touch")
            if side == FluidityPools.monitor.id then
                if y == h-4 then
                    local xx = 2
                    for k,v in pairs(items) do
                        if (xx-1 <= x) and (xx+#k >= x) then
                            selectedCategory = k
                            renderCategories()
                            renderItems()
                            break
                        end
                        xx = xx + #k + 2
                    end
                end
            end
        end
    end
    local function sp_rerender()
        while true do
            os.pullEvent("sp_rerender")
            rerender()
        end
    end
    local function itemChangeListener()
        local was = false
        while true do
            if FluidityPools.itemChangeInfo.is and (FluidityPools.itemChangeInfo.category == selectedCategory) then
                was = true
            end
            if (not FluidityPools.itemChangeInfo.is) and was then
                renderItems()
                was = false
            end
            os.sleep(0)
        end
    end
    parallel.waitForAny(categoryClicker,sp_rerender,itemChangeListener)
end

return frontend
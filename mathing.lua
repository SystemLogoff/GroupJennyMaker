function checkstatus()
    if not testedyet then
        for k,v in pairs(items) do
         print(k,v)
        end
    end
            testedyet = true
end

function findheight(itemnum)
    tempheight = 0
        for k,v in pairs(items) do
             if k < itemnum then
                 tempheight = math.ceil(tempheight + v)
             end
        end
    return tempheight
end

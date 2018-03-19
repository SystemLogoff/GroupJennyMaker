FILLWIDTH = love.graphics.getWidth()
FILLHEIGHT = love.graphics.getHeight()
love.graphics.setDefaultFilter( "linear", "linear", 2 )
items = {}
imgsend = love.graphics.newImage("send.png")
require("colors")
require("graphics")
require("text")
require("font")
require("mathing")

--draw_l_textbox pos jenny_name jenny_text jenny_pic
--draw_r_textbox pos jenny_name jenny_text jenny_pic
--draw_img_r_textbox pos jenny_name text_pic jenny_pic
--draw_img_l_textbox pos jenny_name text_pic jenny_pic

function love.draw()
    draw_bg() -- BG COLOR
    draw_info_bar(0, text.title) -- What chat app is this?

    -- Jenny Chats here

    draw_l_textbox(1, "Angela Jenny", "Doggo picture time!", 20)

    draw_img_r_textbox(2, "Angela Jenny", 3, 20)

    draw_img_r_textbox(3, "Annie Jenny", 2, 7)

    draw_l_textbox(4, "Angela Jenny", "Oh! Peaches' eggs hatched! They already look regal.", 20)

    draw_img_r_textbox(5, "Annie Jenny", 4, 7)

    draw_l_textbox(6, "Angela Jenny", "Aww!", 20)

    -- End Jenny Chats

    draw_bottom_bar(" ")-- Draw message bar on bottom
    checkstatus()
end

function draw_bg()
    color(COLOR.BACKGROUND)
    love.graphics.rectangle("fill", 0, 0, FILLWIDTH, FILLHEIGHT)
    resetColor()
end

function draw_info_bar(itemnum, itemtext)
    local posx = 0
    local posy = findheight(itemnum)

    local ifbheight = FILLHEIGHT/15 -- Bar is 1/10th of the screen big
    local ifbwidth = FILLWIDTH -- covers the whole width

    love.graphics.setFont(bold_font)

    love.graphics.setColor(COLOR.TITLE) -- set color to our known color type
    love.graphics.rectangle("fill", posx, posy, ifbwidth, ifbheight) -- Draw the background bar
    love.graphics.setColor(COLOR.WHITE) -- Reset the color back to normal.

    -- Now we need to center the text, while center X is easy, center Y will be a little tricker
    local ifbfontheight = bold_font:getHeight() -- Get height of the font
    local ifobpadding = ifbheight - ifbfontheight -- get the remaining space left

    color(COLOR.SHADOW) -- Background Text Shadow
    love.graphics.printf(itemtext, posx - 1, posy+ifobpadding/2, FILLWIDTH, "center") -- Divide by two
    love.graphics.printf(itemtext, posx + 1, posy+ifobpadding/2, FILLWIDTH, "center") -- Divide by two
    love.graphics.printf(itemtext, posx, posy+ifobpadding/2 - 1, FILLWIDTH, "center") -- Divide by two
    love.graphics.printf(itemtext, posx, posy+ifobpadding/2 + 1, FILLWIDTH, "center") -- Divide by two
    love.graphics.printf(itemtext, posx, posy+ifobpadding/2 + 2, FILLWIDTH, "center") -- Divide by two
    love.graphics.printf(itemtext, posx-1, posy+ifobpadding/2 + 2, FILLWIDTH, "center") -- Divide by two
    love.graphics.printf(itemtext, posx+1, posy+ifobpadding/2 + 2, FILLWIDTH, "center") -- Divide by two
    love.graphics.setColor(COLOR.WHITE) -- Reset the color back to normal.
    love.graphics.printf(itemtext, posx, posy+ifobpadding/2, FILLWIDTH, "center") -- Divide by two

    color(COLOR.SHADOW) -- Draw shadow under the box
    love.graphics.rectangle("fill", posx, posy + ifbheight, FILLWIDTH, ifbheight/80)
    love.graphics.rectangle("fill", posx, posy + ifbheight, FILLWIDTH, ifbheight/40)
    resetColor()

    items[itemnum] = ifbheight + ifbheight/40
end

function draw_l_textbox(itemnum, jennyname, itemtext, jennypic)
    -- Set up avatar drawing
    local posx = 0
    local posy = findheight(itemnum)
    avatarsize = math.ceil(FILLWIDTH/10)
    avatarx = posx + avatarsize + FILLWIDTH/40
    avatary = posy + avatarsize + FILLHEIGHT/60
    avatarsmooth = 64
    textboxx = posx + (avatarsize * 2) + ((FILLWIDTH/40)*2)
    textboxy = posy + FILLHEIGHT/60
    textboxw = FILLWIDTH - textboxx - FILLWIDTH/40
    textboxh = 100
    textboxr = math.ceil(16)

    atextwidth, atextwrappedtext = text_font:getWrap( itemtext, textboxw -  FILLWIDTH/40 )
    atextfontheight = text_font:getHeight()
    atextfontheight2 = name_font:getHeight()
    nettextheight = (#atextwrappedtext * atextfontheight ) + atextfontheight2 + FILLWIDTH/25
    textboxh = nettextheight

    if textboxh <= avatarsize * 2 then
        textboxh = avatarsize * 2
    end


    -- Draw Shadow behind avatar
    color(COLOR.BLACK)
    love.graphics.circle("line", avatarx, avatary, avatarsize, avatarsmooth)
    resetColor()

    -- ALL OF THIS WORK FOR THE AVATAR
    function myStencilFunction()
        love.graphics.circle("fill", avatarx, avatary, avatarsize, avatarsmooth)
    end
    love.graphics.stencil(myStencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.draw(j[jennypic], posx + FILLWIDTH/40, posy + FILLHEIGHT/60, 0, avatarsize*2/j[jennypic]:getWidth(), avatarsize*2/j[jennypic]:getHeight())
    color(COLOR.BLACK)
    love.graphics.circle("line", avatarx, avatary, avatarsize, avatarsmooth)
    resetColor()
    --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    love.graphics.setStencilTest()

    -- OH BOY, TEXTBOX TIME
    color(COLOR.WHITE)
    love.graphics.rectangle("fill", textboxx, textboxy, textboxw, textboxh, textboxr)
    color(COLOR.BLACK)
    love.graphics.rectangle("line", textboxx , textboxy, textboxw, textboxh, textboxr)

    -- OH BOY TEXT TIME
    -- NAME
    color(COLOR.TITLE)
    love.graphics.setFont(name_font)
    love.graphics.print(jennyname, math.ceil(textboxx + 8), math.ceil(textboxy + 4))
    color(COLOR.BLACK)
    love.graphics.setFont(text_font)
    love.graphics.printf(itemtext, math.ceil(textboxx + 8) , math.ceil(textboxy + 4 + name_font:getHeight()), textboxw - FILLWIDTH/25)

    items[itemnum] = textboxh + FILLHEIGHT/60
    resetColor()
end

function draw_r_textbox(itemnum, jennyname, itemtext, jennypic)
    -- Set up avatar drawing
    local posx = 0
    local posy = findheight(itemnum)

    textboxx = posx + FILLWIDTH/40
    textboxy = posy + FILLHEIGHT/60
    textboxw = FILLWIDTH - textboxx - ((FILLWIDTH/40)*2) - math.ceil((FILLWIDTH/10)*2)
    textboxh = 100
    textboxr = math.ceil(16)

    avatarsize = math.ceil(FILLWIDTH/10)
    avatarx = textboxw + posx + avatarsize + ((FILLWIDTH/40)*2)
    avatary = posy + avatarsize + FILLHEIGHT/60
    avatarsmooth = 64



    atextwidth, atextwrappedtext = text_font:getWrap( itemtext, textboxw -  FILLWIDTH/40 )
    atextfontheight = text_font:getHeight()
    atextfontheight2 = name_font:getHeight()
    nettextheight = (#atextwrappedtext * atextfontheight ) + atextfontheight2 + FILLWIDTH/25
    textboxh = nettextheight

    if textboxh <= avatarsize * 2 then
        textboxh = avatarsize * 2
    end


    -- Draw Shadow behind avatar
    color(COLOR.BLACK)
    love.graphics.circle("line", avatarx, avatary, avatarsize, avatarsmooth)
    resetColor()

    -- ALL OF THIS WORK FOR THE AVATAR
    function myStencilFunction()
        love.graphics.circle("fill", avatarx, avatary, avatarsize, avatarsmooth)
    end
    love.graphics.stencil(myStencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.draw(j[jennypic], avatarx - avatarsize, posy + FILLHEIGHT/60, 0, avatarsize*2/j[jennypic]:getWidth(), avatarsize*2/j[jennypic]:getHeight())
    color(COLOR.BLACK)
    love.graphics.circle("line", avatarx, avatary, avatarsize, avatarsmooth)
    resetColor()
    --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    love.graphics.setStencilTest()

    -- OH BOY, TEXTBOX TIME
    color(COLOR.WHITE)
    love.graphics.rectangle("fill", textboxx, textboxy, textboxw, textboxh, textboxr)
    color(COLOR.BLACK)
    love.graphics.rectangle("line", textboxx , textboxy, textboxw, textboxh, textboxr)

    -- OH BOY TEXT TIME
    -- NAME
    color(COLOR.TITLE)
    love.graphics.setFont(name_font)
    love.graphics.print(jennyname, math.ceil(textboxx + 8), math.ceil(textboxy + 4))
    color(COLOR.BLACK)
    love.graphics.setFont(text_font)
    love.graphics.printf(itemtext, math.ceil(textboxx + 8) , math.ceil(textboxy + 4 + name_font:getHeight()), textboxw - FILLWIDTH/25)

    items[itemnum] = textboxh + FILLHEIGHT/60
    resetColor()
end

function draw_img_l_textbox(itemnum, jennyname, itempic, jennypic)
    -- Set up avatar drawing
    local posx = 0
    local posy = findheight(itemnum)
    avatarsize = math.ceil(FILLWIDTH/10)
    avatarx = posx + avatarsize + FILLWIDTH/40
    avatary = posy + avatarsize + FILLHEIGHT/60
    avatarsmooth = 64
    textboxx = posx + (avatarsize * 2) + ((FILLWIDTH/40)*2)
    textboxy = posy + FILLHEIGHT/60
    textboxw = FILLWIDTH - textboxx - FILLWIDTH/40
    textboxh = im[itempic]:getHeight() * (textboxw/im[itempic]:getWidth())
    textboxr = math.ceil(16)



    -- Draw Shadow behind avatar
    color(COLOR.BLACK)
    love.graphics.circle("line", avatarx, avatary, avatarsize, avatarsmooth)
    resetColor()

    -- ALL OF THIS WORK FOR THE AVATAR
    function myStencilFunction()
        love.graphics.circle("fill", avatarx, avatary, avatarsize, avatarsmooth)
    end
    love.graphics.stencil(myStencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.draw(j[itempic], posx + FILLWIDTH/40, posy + FILLHEIGHT/60, 0, avatarsize*2/j[jennypic]:getWidth(), avatarsize*2/j[jennypic]:getHeight())
    color(COLOR.BLACK)
    love.graphics.circle("line", avatarx, avatary, avatarsize, avatarsmooth)
    resetColor()
    --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    love.graphics.setStencilTest()

    -- OH BOY, TEXTBOX TIME
    --OH BOY, IMAGE TIME
        function myStencilFunction()
            love.graphics.rectangle("fill", textboxx, textboxy, textboxw, textboxh, textboxr)
        end
        love.graphics.stencil(myStencilFunction, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.draw(im[itempic], textboxx, textboxy, 0, textboxw/im[itempic]:getWidth(), textboxw/im[itempic]:getWidth())

        resetColor()
        --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
        love.graphics.setStencilTest()
    color(COLOR.BLACK)
    love.graphics.rectangle("line", textboxx , textboxy, textboxw, textboxh, textboxr)
        -- NAME
        love.graphics.setFont(name_font)

        color({255,255,255,100})
        love.graphics.rectangle("fill", math.ceil(textboxx + 8) - 2, math.ceil(textboxy + 4) , name_font:getWidth(jennyname) + 4, name_font:getHeight() + 2, 2)
        color(COLOR.TITLE)
        love.graphics.print(jennyname, math.ceil(textboxx + 8), math.ceil(textboxy + 4))
    resetColor()


    resetColor()
    items[itemnum] = textboxh + FILLHEIGHT/60
end

function draw_img_r_textbox(itemnum, jennyname, itempic, jennypic)
    -- Set up avatar drawing
    local posx = 0
    local posy = findheight(itemnum)
    textboxx = posx + FILLWIDTH/40
    textboxy = posy + FILLHEIGHT/60
    textboxw = FILLWIDTH - textboxx - ((FILLWIDTH/40)*2) - math.ceil((FILLWIDTH/10)*2)
    textboxh = 100
    textboxr = math.ceil(16)

    avatarsize = math.ceil(FILLWIDTH/10)
    avatarx = textboxw + posx + avatarsize + ((FILLWIDTH/40)*2)
    avatary = posy + avatarsize + FILLHEIGHT/60
    avatarsmooth = 64
    textboxh = im[itempic]:getHeight() * (textboxw/im[itempic]:getWidth())
    textboxr = math.ceil(16)



    -- Draw Shadow behind avatar
    color(COLOR.BLACK)
    love.graphics.circle("line", avatarx, avatary, avatarsize, avatarsmooth)
    resetColor()

    -- ALL OF THIS WORK FOR THE AVATAR
    function myStencilFunction()
        love.graphics.circle("fill", avatarx, avatary, avatarsize, avatarsmooth)
    end
    love.graphics.stencil(myStencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.draw(j[jennypic], avatarx - avatarsize, posy + FILLHEIGHT/60, 0, avatarsize*2/j[jennypic]:getWidth(), avatarsize*2/j[jennypic]:getHeight())
    color(COLOR.BLACK)
    love.graphics.circle("line", avatarx, avatary, avatarsize, avatarsmooth)
    resetColor()
    --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    love.graphics.setStencilTest()

    -- OH BOY, TEXTBOX TIME
    --OH BOY, IMAGE TIME
        function myStencilFunction()
            love.graphics.rectangle("fill", textboxx, textboxy, textboxw, textboxh, textboxr)
        end
        love.graphics.stencil(myStencilFunction, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.draw(im[itempic], textboxx, textboxy, 0, textboxw/im[itempic]:getWidth(), textboxw/im[itempic]:getWidth())

        resetColor()
        --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
        love.graphics.setStencilTest()
    color(COLOR.BLACK)
    love.graphics.rectangle("line", textboxx , textboxy, textboxw, textboxh, textboxr)
        -- NAME
        love.graphics.setFont(name_font)

        color({255,255,255,100})
        love.graphics.rectangle("fill", math.ceil(textboxx + 8) - 2, math.ceil(textboxy + 4) , name_font:getWidth(jennyname) + 4, name_font:getHeight() + 2, 2)
        color(COLOR.TITLE)
        love.graphics.print(jennyname, math.ceil(textboxx + 8), math.ceil(textboxy + 4))
    resetColor()


    resetColor()
    items[itemnum] = textboxh + FILLHEIGHT/60
end

function draw_bottom_bar(itemtext) -- This has scaling issues but I don't care enough to fix it since it does the job
    local posx = 0
    local posy = FILLHEIGHT - FILLHEIGHT/15

    local ifbheight = FILLHEIGHT/15 -- Bar is 1/10th of the screen big
    local ifbwidth = FILLWIDTH -- covers the whole width

    love.graphics.setFont(text_font)

    love.graphics.setColor(COLOR.TITLE) -- set color to our known color type

    love.graphics.rectangle("fill", posx, posy, ifbwidth, ifbheight) -- Draw the background bar

    love.graphics.setColor(COLOR.WHITE) -- Reset the color back to normal.
    love.graphics.rectangle("fill", posx + 10, posy + 10, ifbwidth - 80, ifbheight - 20, 16) -- Draw the background bar
    --love.graphics.rectangle("fill", posx + 10 + ifbwidth - 70, posy + 10, 50, ifbheight - 20, 16) -- Draw the background bar
    love.graphics.setColor(COLOR.AVATARAA) -- Reset the color back to normal.
    love.graphics.rectangle("line", posx + 10, posy + 10, ifbwidth - 80, ifbheight - 20, 16) -- Draw the background bar
    --love.graphics.rectangle("line", posx + 10 + ifbwidth - 70, posy + 10, 50, ifbheight - 20, 16) -- Draw the background bar

    love.graphics.setFont(text_font)
    -- Now we need to center the text, while center X is easy, center Y will be a little tricker
    local ifbfontheight = text_font:getHeight() -- Get height of the font
    local ifobpadding = ifbheight - ifbfontheight -- get the remaining space left
    love.graphics.setColor(COLOR.BLACK) -- Reset the color back to normal.
    love.graphics.printf(itemtext, posx + 15, posy+ifobpadding/2, FILLWIDTH, "left") -- Divide by two

    color(COLOR.SHADOW) -- Draw shadow under the box
    love.graphics.rectangle("fill", posx, posy - ifbheight/80, FILLWIDTH, ifbheight/80)
    love.graphics.rectangle("fill", posx, posy - ifbheight/40, FILLWIDTH, ifbheight/40)
        love.graphics.setColor(COLOR.TITLE) -- set color to our known color type
        love.graphics.setFont(name_font)
        love.graphics.print("+", posx + 10 + ifbwidth - 105, posy+ifobpadding/2 - 4)
        love.graphics.setFont(name_font)
    resetColor()
            love.graphics.draw(imgsend, posx + 10 + ifbwidth - 60, posy+ifobpadding/2 - 7)
end

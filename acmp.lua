-- Animal Crossing Music Player (Rockbox)

BASE_PATH = "/acmp-ipod/"

BTN_MENU = 2
BTN_PREV = 4
BTN_NEXT = 8
BTN_SELECT = 1

games = {
    "new-horizons",
    "new-leaf",
    "wild-world",
    "animal-crossing"
}

weather_types = {
    "sunny",
    "raining",
    "snowing"
}

game_index = 1
weather_index = 1


function get_hour()

    local t = os.date("*t")
    local hour = t.hour
    local suffix = "am"

    if hour >= 12 then
        suffix = "pm"
    end

    hour = hour % 12
    if hour == 0 then
        hour = 12
    end

    return tostring(hour) .. suffix
end


function build_track()

    local hour = get_hour()
    local game = games[game_index]
    local weather = weather_types[weather_index]

    -- fallback para Animal Crossing (GameCube)
    if game == "animal-crossing" and weather == "raining" then
        return BASE_PATH .. game .. "/raining.mp3"
    end

    return BASE_PATH ..
        game ..
        "/" ..
        hour ..
        "_" ..
        weather ..
        ".mp3"
end


function file_exists(path)

    local f = io.open(path,"r")

    if f then
        io.close(f)
        return true
    end

    return false
end


function show_message(msg)

    rb.lcd_clear_display()
    rb.lcd_puts(0,0,msg)
    rb.lcd_puts_scroll(0,2,msg)
    rb.lcd_update()

    rb.sleep(200)
end


function play_track()

    local path = build_track()
    
    rb.audio("stop")

--    debug_screen("Track:", path)

    if not file_exists(path) then
--        debug_screen("Missing:", path)
        return false
    end

    rb.playlist("remove_all_tracks")
    rb.playlist("create", "/", "acmp_temp.m3u")
    rb.playlist("insert_track", path, rb.PLAYLIST_INSERT_LAST, false, true)
    rb.playlist("start", 0, 0, 0)

    return true

end


function draw_list(title, list, index)

    rb.lcd_clear_display()

    rb.lcd_puts(0,0,title)

    for i=1,#list do

        local prefix = "  "

        if i == index then
            prefix = "> "
        end

        rb.lcd_puts(0,i+1,prefix .. list[i])

    end

    rb.lcd_puts(0,7,"<< =up  >> =down  MIDDLE BTN =ok")

    rb.lcd_update()

end


function list_menu(title,list)

    local index = 1

    while true do

        draw_list(title,list,index)

        local button = rb.button_get(true)

        if button == BTN_PREV then
            index = index - 1
            if index < 1 then index = #list end
        end

        if button == BTN_NEXT then
            index = index + 1
            if index > #list then index = 1 end
        end

        if button == BTN_SELECT then
            return index
        end

        if button == BTN_MENU then
            return nil
        end

    end

end

function settings_menu()

    local options = {
        "Select Game",
        "Select Weather",
        "Start Player",
        "Back",
        "Quit"
    }

    while true do

        local r = list_menu("ACMP - Animal Crossing Music Player", options)

        if r == 1 then

            local g = list_menu("Game", games)
            if g then game_index = g end

        elseif r == 2 then

            local w = list_menu("Weather", weather_types)
            if w then weather_index = w end

        elseif r == 3 then

            local ok = play_track()

            if ok then
                return true
            end

        elseif r == 4 then
            -- voltar para o player sem reiniciar música
            return true

        elseif r == 5 then
            rb.audio("stop")
            return false
        end

    end

end


function draw_ui()

    rb.lcd_clear_display()

    rb.lcd_puts(0,0,"AC Music Player")

    rb.lcd_puts(0,2,"Game: "..games[game_index])
    rb.lcd_puts(0,3,"Weather: "..weather_types[weather_index])
    rb.lcd_puts(0,4,"Hour: "..get_hour())

    rb.lcd_puts(0,6,"MENU = settings")

    rb.lcd_update()

end

function debug_screen(line1, line2)

    rb.lcd_clear_display()

    rb.lcd_puts(0,0,line1)

    if line2 then
        rb.lcd_puts_scroll(0,2,line2)
    end

    rb.lcd_update()

    rb.button_get(true)

end

function main()

    local start = settings_menu()

    if not start then
        return
    end

    while true do

        draw_ui()

        local status = rb.audio("status")

        if status == 0 then

            local ok = play_track()

            if not ok then
                settings_menu()
            end

        end

        local ev = rb.button_get(false)

        if ev == BTN_MENU then

            local again = settings_menu()

            if not again then
                rb.audio("stop")
                return
            end

        end

        rb.sleep(10)

    end

end


main()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Thug Hub - Pirates Quest 3", "DarkTheme")

local Tab = Window:NewTab("Main")

local Section = Tab:NewSection("Options")

local ts = game:GetService("TweenService")

function Tween(part, endpos, speed)
    if part and endpos then
        local Time = (endpos - part.Position).magnitude/speed
        local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
        local Tween = ts:Create(part,Info,{CFrame = CFrame.new(endpos.X,endpos.Y,endpos.Z)})
        Tween:Play()
        wait(Time)
    end
end

Section:NewToggle("Fruit Picking Aura", "ToggleInfo", function(state)
    if state then
        getgenv().fruitaura = true
    else
        getgenv().fruitaura = false
    end

    while fruitaura do task.wait(0.2)
       task.spawn(function()
            for i, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("StringValue") and v.Parent.Name == "Tree" then
                    for h, j in pairs(v.Parent.Fruit:GetDescendants()) do
                        if j.Name == "Handle" then
                            local closest = (game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - j.Position).magnitude
                            if closest < 20 then
                                --print(closest)
                                fireclickdetector(j.ClickDetector)
                            end
                   end
               end
           end
       end
    end)
    end
end)


Section:NewButton("Check for Fruit", "ButtonInfo", function()
    local colors = {"Bright yellow", "Crimson", "Medium stone grey", "Reddish brown"}

    for i, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("StringValue") and v.Parent.Name == "Tree" then
            for h, j in pairs(v.Parent.Fruit:GetDescendants()) do
                if j.Name == "Handle" then
                    if not table.find(colors, tostring(j.BrickColor)) then
                        print(j.BrickColor)
                        game:GetService("StarterGui"):SetCore("SendNotification",{
                            Title = "Fruit Found", -- Required
                            Text = tostring(j.BrickColor), -- Required
                        })
                    end
                end
            end
        end
    end
end)

Section:NewToggle("Auto Clear Inventory", "ToggleInfo", function(state)
    if state then
        getgenv().invclear = true
    else
        getgenv().invclear = false
    end
    
    local fruits = {"Apple", "Orange", "Coconut", "Banana", "Lemon"}
    
    while getgenv().invclear do wait(5)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and table.find(fruits, v.Name) then
            v:Destroy()
        end
    end
    end
end)

getgenv().tweenspeed = 250
Section:NewSlider("Tween Speed", "SliderInfo", 1500, 100, function(s) -- 500 (MaxValue) | 0 (MinValue)
    getgenv().tweenspeed = s
end)

Section:NewToggle("TP to Trees", "ToggleInfo", function(state)
    if state then
        getgenv().treefarm = true
        setfflag("HumanoidParallelRemoveNoPhysics", "False")
        setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
    else
        getgenv().treefarm = false
        setfflag("HumanoidParallelRemoveNoPhysics", "True")
        setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "True")
    end
    
    game:GetService('RunService').Stepped:connect(function()
        if getgenv().treefarm then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(11)
        end
    end)
    
    while getgenv().treefarm do
            wait()
            for _,v in pairs(game.Workspace:GetDescendants()) do
              if v.ClassName == "Model" and v:FindFirstChild("Fruit") and (#v:FindFirstChild("Fruit"):GetChildren()) ~= 0 and getgenv().treefarm == true then
                  Tween(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, v.Part.Position, getgenv().tweenspeed)
                  wait(2)
              end
            end
    end
end)

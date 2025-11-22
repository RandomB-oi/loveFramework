Engine = Instance.new("Scene")
Engine.Name = "Engine"
Engine.Replicates = false

Engine:GetService("RunService")

for className, info in pairs(Instance.Classes) do
	if info:IsA("BaseService") then
		Engine:GetService(className)
	end
end
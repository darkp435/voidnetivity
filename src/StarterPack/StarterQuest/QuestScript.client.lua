local tool = script.Parent

local DIALOGUE_1 = {
	"Hello! Weird sort of place isn't it?",
	"Yes, I know, this place is weird.",
	"It was when I got here and I felt just like you.",
	"Over time, I've gotten quite used to it",
	"But that doesn't mean I know everything.",
	"Things still regularly surprise me!",
	"Like, I've been here longer than anyone else,",
	"...and yet it still surprised me when I learnt privilege escalation.",
	"Actually, I shouldn't give too much away at once.",
	"Part of the fun is discovering new things...",
	"...and seeing what use you can make!",
	"...",
	"Where was I?",
	"...",
	"Oh, somewhere to start?",
	"I'm not the best at teaching, though!",
	"...",
	"How about this? I give you quests to learn things...",
	"...and I'll give you things in return when you apply those skills!",
	"How does that sound?",
	"Ok, let me think of somewhere to start...",
	"... [thinking] ...",
	"I've got it! Files!",
	"Files are the bane of literally everything.",
	"Files are used for everything you do.",
	"They're your sword, shield, guards, walls, everything.",
	"Different files so different things",
	"...which you can get a rough idea of from their name.",
	"I see you already have found a few.",
	"However, there's always more files to discover...",
	"And you'll find them on remote hosts.",
	"...",
	"What's that?",
	"What's a remote host?",
	"Oh right, I forgot to tell you.",
	"You know where we are right now?",
	"That's one host.",
	"Think of it as our home.",
	"About remote hosts...",
	"There's thousands of these hosts out there...",
	"...and that's 0% hyperbole.",
	"Like, seriously.",
	"You don't trust me? There's like... actually no I can't count.",
	"But do that after my quest.",
	"If this host is our home,",
	"...think of the other hosts as other buildings",
	"On remote hosts, you can find new files.",
	"You can also take over them and protect them",
	"...but I'm getting too ahead of myself.",
	"However, here's the thing.",
	"You're new, so you have no access to any hosts.",
	"...",
	"Why, you ask?",
	"Well, you just don't.",
	"So, you must hack into these hosts.",
	"You must break in.",
	"There are no rules but the rule of files.",
	"Why would you hack a host?",
	"Like I said, the files.",
	"But also it's exploration, which is fun.",
	"Through going to new hosts,",
	"...you learn things that I could never put in words.",
	"That's the first thing I want you to do.",
	"I see you have already picked up brute.exe",
	"This is used to hack remote hosts.",
	"There are other ways with other files,",
	"...but you'll get those files later as they aren't important as of right now",
	"Files beget better files.",
	"The cycle keeps repeating.",
	"With the good files you have everything.",
	"Without, you have nothing.",
	"Anyways, here's what I want you to do.",
	"Use brute.exe to hack 5 remote hosts.",
	"Well actually you can use any file if you get some more",
	"While you're there, you might as well get some files.",
	"And I'll sweeten the deal...",
	"...by giving you some Bitcoin!",
	"Bitcoin is useful for a whole lot of things, but it's for you to figure out.",
	"Where did I get this? Don't ask.",
	"...",
	"What's that?",
	"...",
	"Why am I even doing this, you ask?",
	"...",
	"Well, it's a long story.",
	"When I first came here, there was no one but me.",
	"I had to figure stuff out myself.",
	"However, I had lots of fun.",
	"Now, this place is full of players like you and me.",
	"I want to share the fun I had...",
	"...with everyone, by giving them knowledge and incentive.",
	"This is very fulfilling in its own",
	"I have all the time I've the world...",
	"...so I might as well.",
	"...",
	"Yeah, I've talked enough.",
	"Try the things I told you,",
	"...and come back for more quests!",
	"Best of luck to your endeavors."
}

local ptr = 1
local button

tool.Equipped:Connect(function()
	local player = game.Players.LocalPlayer
	local gui = player:WaitForChild("PlayerGui")

	-- Check if GUI already exists
	local screenGui = gui:FindFirstChild("ScreenGui")
	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "MyScreenGui"
		screenGui.Parent = gui
	end

	-- Create a button
	button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 400, 0, 100)
	button.Position = UDim2.new(0.5, 0, 0.5, 0)
	button.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui
	button.Text = DIALOGUE_1[ptr]
	
	button.MouseButton1Click:Connect(function() 
		if ptr < #DIALOGUE_1 then
			ptr = ptr + 1
		else
			button:Destroy()
		end
		button.Text = DIALOGUE_1[ptr]
	end)
end)

tool.Unequipped:Connect(function() 
	button:Destroy()
end)
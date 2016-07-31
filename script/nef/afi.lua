--
Afi={}
--AFI
local AFI = false
EVENT_ADJ_LOC = 2000
EVENT_ADJ_ATK = 2001
EVENT_ADJ_DEF = 2002
EVENT_ADJ_LEV = 2003
EVENT_ADJ_RANK = 2004
EVENT_ADJ_RACE = 2005
EVENT_ADJ_ATTR = 2006
EVENT_ADJ_DISABLE = 2007
local ms = {}
ms[0] = {}
ms[1] = {}
for i=0,5 do
    ms[0][i] = {}
    ms[1][i] = {}
end
function Afi.AdjustFieldInfoStore(c)
	if AFI==true then return end
	AFI = true
	--store
	local g=Group.CreateGroup()
	g:KeepAlive()
	--adjust
	local e0=Effect.CreateEffect(c)
	--local e0=Effect.GlobalEffect()
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetOperation(Afi.AdjustFieldInfoCheck)
	e0:SetLabelObject(g)
	Duel.RegisterEffect(e0, 0)
end
function Afi.AdjustFieldInfoCheck(e,tp,eg,ep,ev,re,r,rp)
	--define
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local preg=e:GetLabelObject()

	if g:GetCount()>0 then
		--check
		Afi.AdjustFieldInfoCheckMI(g,preg,e)
		--renew	
		preg:Clear()
		preg:Merge(g)
		Afi.AdjustFieldInfoRenewMI(g)
	else
		if preg:GetCount()==0 then return end
		preg:Clear()
	end
end
function Afi.AdjustFieldInfoCheckMI(g,preg,e)
	local n = -1
	local p = -1
	local pn = -1
	local pp = -1
	local tempg1 = {}
	local tempg2 = {}
	for i=0,7 do
   		tempg1[i] = Group.CreateGroup()
		tempg2[i] = Group.CreateGroup()
	end
	local tempc = g:GetFirst()	
	while(tempc) do
		p = tempc:GetControler()
		n = tempc:GetSequence()
		if preg:IsContains(tempc) then
			pp,pn = Afi.AdjustFieldInfoFindMI(tempc)
			if pp<0 or pn<0 then return end
			if n~=pn and p==pp then 
				Duel.RaiseSingleEvent(tempc,EVENT_ADJ_LOC,e,0,0,0,pn)
				tempg1[0]:AddCard(tempc)
			end
			if ms[pp][pn][1]~=tempc:GetAttack() then
				Duel.RaiseSingleEvent(tempc,EVENT_ADJ_ATK,e,0,0,0,ms[pp][pn][1])
				if ms[pp][pn][1]<tempc:GetAttack() then tempg1[1]:AddCard(tempc)
				else                                    tempg2[1]:AddCard(tempc) end
			end
			if ms[pp][pn][2]~=tempc:GetDefence() then
				Duel.RaiseSingleEvent(tempc,EVENT_ADJ_DEF,e,0,0,0,ms[pp][pn][2]) 
				if ms[pp][pn][2]<tempc:GetDefence() then tempg1[2]:AddCard(tempc)
				else                                    tempg2[2]:AddCard(tempc) end
			end
			if ms[pp][pn][3]~=tempc:GetLevel() then
				Duel.RaiseSingleEvent(tempc,EVENT_ADJ_LEV,e,0,0,0,ms[pp][pn][3]) 
				if ms[pp][pn][3]<tempc:GetLevel() then tempg1[3]:AddCard(tempc)
				else                                   tempg2[3]:AddCard(tempc) end
			end
			if ms[pp][pn][4]~=tempc:GetRank() then 
				Duel.RaiseSingleEvent(tempc,EVENT_ADJ_RANK,e,0,0,0,ms[pp][pn][4]) 
				if ms[pp][pn][4]<tempc:GetRank() then tempg1[4]:AddCard(tempc)
				else                                  tempg2[4]:AddCard(tempc) end
			end
			if ms[pp][pn][5]~=tempc:GetRace() then 
				Duel.RaiseSingleEvent(tempc,EVENT_ADJ_RACE,e,0,0,0,ms[pp][pn][5]) 
				tempg1[5]:AddCard(tempc)
			end
			if ms[pp][pn][6]~=tempc:GetAttribute() then 
				Duel.RaiseSingleEvent(tempc,EVENT_ADJ_ATTR,e,0,0,0,ms[pp][pn][6]) 
				tempg1[6]:AddCard(tempc)
			end
			if ms[pp][pn][7]~=tempc:IsDisabled() then 
				--Duel.RaiseSingleEvent(tempc,EVENT_ADJ_DISABLE,e,0,0,0,ms[pp][pn][7])
				if tempc:IsDisabled() then Duel.RaiseSingleEvent(tempc,EVENT_ADJ_DISABLE,e,0,0,0,1)
				else                       Duel.RaiseSingleEvent(tempc,EVENT_ADJ_DISABLE,e,0,0,0,2) end
				if ms[pp][pn][7] == false then tempg1[7]:AddCard(tempc)
				else                           tempg2[7]:AddCard(tempc) end
			end
		end
		tempc = g:GetNext()
	end
	for i=0,7 do
   		if tempg1[i]:GetCount()>0 then Duel.RaiseEvent(tempg1[i],2000+i,e,0,0,0,1) end
		if tempg2[i]:GetCount()>0 then Duel.RaiseEvent(tempg2[i],2000+i,e,0,0,0,2) end
	end
end
function Afi.AdjustFieldInfoRenewMI(g)
	local n = -1
	local p = -1
	for i=0,5 do
    	ms[0][i][0] = nil
		ms[1][i][0] = nil
	end
	tempc = g:GetFirst()	
	while(tempc) do
		n = tempc:GetSequence()
		p = tempc:GetControler()
		ms[p][n][0] = tempc
		ms[p][n][1] = tempc:GetAttack()
		ms[p][n][2] = tempc:GetDefence()
		ms[p][n][3] = tempc:GetLevel()
		ms[p][n][4] = tempc:GetRank()
		ms[p][n][5] = tempc:GetRace()
		ms[p][n][6] = tempc:GetAttribute()
		ms[p][n][7] = tempc:IsDisabled()
		tempc = g:GetNext()
	end
end
function Afi.AdjustFieldInfoFindMI(c)
	local i,j
	for i=0,1 do
		for j=0,5 do
   		 	if ms[i][j][0] == c then return i,j end
		end
	end
	return -1,-1
end
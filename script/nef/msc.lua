--
Msc={}
--mscarr
local mscarr = {}
local mscarr2 = {}
for i=0,7 do
    mscarr[i] = {}
	for j=0,7 do
   		mscarr[i][j] = 0
	end
end
for i=0,5 do
    mscarr2[i] = {}
	for j=1,4 do
   		mscarr2[i][j] = 0
	end
end
--
mscarr[1][5] = 888184
mscarr[1][6] = 888183
mscarr[2][5] = 888185
mscarr[5][6] = 888186
mscarr[2][3] = 888167
mscarr[3][4] = 888168
mscarr[0][3] = 888169
mscarr[1][2] = 888170
mscarr[1][3] = 888171
mscarr[2][4] = 888172
mscarr[0][2] = 888174
mscarr[0][1] = 888175
mscarr[0][4] = 888173
--mscarr[0][4] = 888176
--mscarr[0][4] = 888194
--
mscarr2[3][2] = 888136
mscarr2[2][2] = 888137
mscarr2[1][2] = 888138
mscarr2[0][2] = 888139
mscarr2[4][2] = 888140
mscarr2[3][3] = 888151
mscarr2[2][3] = 888152
mscarr2[1][3] = 888153
mscarr2[0][3] = 888154
mscarr2[4][3] = 888155

function unpack(t, i)
    i = i or 1
    if t[i] then
       return t[i], unpack(t, i + 1)
    end
end
function Msc.GetScSetCard(c1)
	local sn1 = -1
	if c1:IsSetCard(0x178) then sn1 = 3
	elseif c1:IsSetCard(0x179) then sn1 = 2
	elseif c1:IsSetCard(0x180) then sn1 = 1
	elseif c1:IsSetCard(0x181) then sn1 = 0
	elseif c1:IsSetCard(0x182) then sn1 = 4
	elseif c1:IsSetCard(0x183) then sn1 = 5
	elseif c1:IsSetCard(0x184) then sn1 = 6
	elseif c1:GetOriginalCode()==22200 then sn1 = 7 end
	return sn1
end
function Msc.IsCanMix2(c1,c2)
	local sn1 = Msc.GetScSetCard(c1)
	local sn2 = Msc.GetScSetCard(c2)
	if sn1==7 or sn2==7 then return true end
	if sn1<0 or sn1>6 then return false end
	if sn2<0 or sn2>6 then return false end
	if bit.bor(mscarr[sn1][sn2],mscarr[sn2][sn1])~=0 then return true end
	return false
end
function Msc.GetMix2(c1,c2,tp)
	local sn1 = Msc.GetScSetCard(c1)
	local sn2 = Msc.GetScSetCard(c2)
	local code = bit.bor(mscarr[sn1][sn2],mscarr[sn2][sn1])
	if code == 888173 then 
		local temp = Duel.SelectOption(tp, 22200*16+10, 22200*16+11, 22200*16+12) 
		if temp == 0 then code = 888173
		elseif temp == 1 then code = 888176
		elseif temp == 2 then code = 888194
		end
	end
	return code
end
function Msc.GetMix2or3(sn1,num,tp)
	local code = mscarr2[sn1][num]
	return code
end
function Msc.ScMix(g,tp)
	local c1 = g:GetFirst()
	local c2 = g:GetNext()
	local code = Msc.GetMix2(c1,c2,tp)
	local token=Duel.CreateToken(tp,code)
	return token
end
function Msc.ScMix2(g,tp,flag)
	local c1 = g:GetFirst()
	local sn1 = Msc.GetScSetCard(c1)
	local num = g:GetCount()
	local code = Msc.GetMix2or3(sn1,num+flag,tp)
	local token=Duel.CreateToken(tp,code)
	return token
end
function Msc.ScMixWithLW(g,tp)
	local c1 = g:GetFirst()
	local sn1 = Msc.GetScSetCard(c1)
	local code = 0
	local temp = 0
	local select_tabel_string = {}
	local select_tabel_int = {}
	local tabel_hpoint = 1
	while temp<7 do
		if bit.bor(mscarr[sn1][temp],mscarr[temp][sn1]) ~= 0 then 
			select_tabel_string[tabel_hpoint] = 22200*16+temp
			select_tabel_int[tabel_hpoint] = temp
			tabel_hpoint = tabel_hpoint + 1
		end
		temp = temp + 1
	end
	if tabel_hpoint>0 then
		temp = Duel.SelectOption(tp, unpack(select_tabel_string))
		temp = temp + 1
		code = bit.bor(mscarr[sn1][select_tabel_int[temp]],mscarr[select_tabel_int[temp]][sn1])
		if code == 888173 then 
			local temp2 = Duel.SelectOption(tp, 22200*16+10, 22200*16+11, 22200*16+12) 
			if temp2 == 0 then code = 888173
			elseif temp2 == 1 then code = 888176
			elseif temp2 == 2 then code = 888194
			end
		end
		local token=Duel.CreateToken(tp,code)
		return token
	end
	return 0
	-- while code == 0 do
		-- temp = Duel.SelectOption(tp, 22200*16+0, 22200*16+1, 22200*16+2, 22200*16+3, 22200*16+4, 22200*16+5, 22200*16+6)
		-- code = bit.bor(mscarr[sn1][temp],mscarr[temp][sn1])
		-- if code==0 then Duel.SelectOption(tp,22200*16+7) end
	-- end
	-- if code == 888173 then 
		-- local temp2 = Duel.SelectOption(tp, 22200*16+10, 22200*16+11, 22200*16+12) 
		-- if temp2 == 0 then code = 888173
		-- elseif temp2 == 1 then code = 888176
		-- elseif temp2 == 2 then code = 888194
		-- end
	-- end
	-- local token=Duel.CreateToken(tp,code)
	-- return token
end
function Msc.RegScMixEffect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(22200,8))
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(Msc.RegScMixEffectTarget)
	e3:SetOperation(Msc.RegScMixEffectOperation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(22200,9))
	e4:SetTarget(Msc.RegScMixEffectTarget2)
	e4:SetOperation(Msc.RegScMixEffectOperation2)
	c:RegisterEffect(e4)
end
function Msc.RScMEdactfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x811)
end
function Msc.RScMEmfilter1(c,this_card)
	return c:IsFaceup() and Msc.IsCanMix2(c,this_card)
end
function Msc.RScMEmfilter2(c,setcode)
	local sn = Msc.GetScSetCard(c)
	return c:IsFaceup() and (sn==setcode or sn==7)
end
function Msc.RScMEmfilterForTheLW(c)
	return c:GetOriginalCode()==22200
end
function Msc.RegScMixEffectTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mq=Duel.IsExistingMatchingCard(Msc.RScMEdactfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return (mq or Duel.CheckLPCost(tp,1000)) and
		Duel.IsExistingMatchingCard(Msc.RScMEmfilter1,tp,LOCATION_SZONE,0,1,c,c) end
	if not mq then
		Duel.PayLPCost(tp,1000)
	end
	Duel.SetChainLimit(aux.FALSE)
end
function Msc.RegScMixEffectOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Msc.RScMEmfilter1,tp,LOCATION_SZONE,0,1,1,c,c)
	if g:GetCount()>0 then g:AddCard(c) end
	
	local flag = g:FilterCount(Msc.RScMEmfilterForTheLW,nil)
	if flag==1 then 
		if Duel.SendtoGrave(g,REASON_MATERIAL)~=0 then
			--if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			g:Remove(Msc.RScMEmfilterForTheLW,nil)
			local tc = Msc.ScMixWithLW(g,tp)
			if tc ~= 0 then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	elseif flag==0 then
		if Duel.SendtoGrave(g,REASON_MATERIAL)~=0 then
			--if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			local tc = Msc.ScMix(g,tp)
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	
end
function Msc.RegScMixEffectTarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sn=Msc.GetScSetCard(c)
	local mq=Duel.IsExistingMatchingCard(Msc.RScMEdactfilter,tp,LOCATION_MZONE,0,1,nil) 
	if chk==0 then return (mq or Duel.CheckLPCost(tp,1000))
		and sn>=0 and sn<=4
		and Duel.IsExistingMatchingCard(Msc.RScMEmfilter2,tp,LOCATION_SZONE,0,1,c,sn) end
	if not mq then
		Duel.PayLPCost(tp,1000)
	end
	Duel.SetChainLimit(aux.FALSE)
end
function Msc.RegScMixEffectOperation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Msc.RScMEmfilter2,tp,LOCATION_SZONE,0,1,2,c,Msc.GetScSetCard(c))
	if g:GetCount()>0 then g:AddCard(c) end
	
	local flag = g:FilterCount(Msc.RScMEmfilterForTheLW,nil)
	if flag==1 then g:Remove(Msc.RScMEmfilterForTheLW,nil) end
	if Duel.SendtoGrave(g,REASON_MATERIAL)~=0 then
		--if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
		local tc = Msc.ScMix2(g,tp,flag)
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)
		Duel.ConfirmCards(1-tp,tc)
	end
end
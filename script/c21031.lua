 
--迷途竹林
function c21031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21031,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c21031.spcon)
	e2:SetTarget(c21031.sptg)
	e2:SetOperation(c21031.spop)
	e2:SetLabelObject(g)
	c:RegisterEffect(e2)
end

c21031.DescSetName=0x258

function c21031.spcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst():GetSummonType()~=SUMMON_TYPE_SPECIAL+0x20 then
		e:GetLabelObject():Clear()
		e:GetLabelObject():Merge(eg)
		return true
	else return false end
end
function c21031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c21031.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	if not tc then return end
	local s0=false
	local s1=false
	while tc do
		if tc:IsControler(tp) then s0=true
		else s1=true end
		-- if tc:IsFaceup() then
			-- local e1=Effect.CreateEffect(e:GetHandler())
			-- e1:SetType(EFFECT_TYPE_SINGLE)
			-- e1:SetCode(EFFECT_SET_POSITION)
			-- e1:SetValue(POS_FACEUP_DEFENCE)
			-- e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			-- tc:RegisterEffect(e1)
		-- end
		if tc:IsAttackPos() then                      --
			Duel.ChangePosition(tc,POS_FACEUP_DEFENCE)--
		end                                           --
		tc=g:GetNext()
	end
	if s0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21035,0,0x4011,600,600,2,RACE_BEASTWARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK,1-tp) then
		local token=Duel.CreateToken(tp,21035)
		Duel.SpecialSummonStep(token,0x20,tp,1-tp,false,false,POS_FACEUP_DEFENCE)
	end
	if s1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21035,0,0x4011,600,600,2,RACE_BEASTWARRIOR,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(1-tp,21035)
		Duel.SpecialSummonStep(token,0x20,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
	Duel.SpecialSummonComplete()
end

--幻想春花
function c25151.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c25151.target)
	e1:SetOperation(c25151.activate)
	c:RegisterEffect(e1)
	if not c25151.global_check then
		c25151.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c25151.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c25151.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(Card.IsSetCard,nil,0x3208)>0 then
		Duel.RegisterFlagEffect(rp,25151,RESET_PHASE+PHASE_END,0,1)
	end
end
function c25151.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c25151.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25151.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,25161,0x208,0x4011,2000,2000,5,RACE_PLANT,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENCE,1-tp) end
	local sg=Duel.GetMatchingGroup(c25151.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c25151.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c25151.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	if Duel.IsPlayerCanSpecialSummonMonster(tp,25161,0x208,0x4011,2000,2000,5,RACE_PLANT,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENCE,1-tp) then
		Duel.BreakEffect()
		for i = 1,2 do
			local token=Duel.CreateToken(tp,25161)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENCE)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(1)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(1)
			token:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c25151.op)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c25151.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,25151)>0 then return end
	local lpc=Duel.GetLP(tp)
	Duel.SetLP(tp,lpc-1000)
end

--喜欢坂道的神明✿八坂神奈子
function c23150.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x497),aux.FilterBoolFunction(c23150.fusfilter),true)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23150,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c23150.settg1)
	e1:SetOperation(c23150.setop1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23150,1))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c23150.condition)
	e2:SetCost(c23150.cost)
	e2:SetTarget(c23150.target)
	e2:SetOperation(c23150.operation)
	c:RegisterEffect(e2)
end
c23150.material_setcode=0x497
function c23150.fusfilter(c)
	return c:GetCounter(0x28a)>0
end
function c23150.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c23150.settg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,231500,0,0x4011,500,2000,10,RACE_ROCK,ATTRIBUTE_EARTH)
		and Duel.IsExistingMatchingCard(c23150.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c23150.setop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c23150.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,231500,0,0x4011,500,2000,10,RACE_ROCK,ATTRIBUTE_EARTH) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,231500)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c23150.cfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsFaceup()
end
function c23150.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c23150.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c23150.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 and Duel.CheckReleaseGroup(tp,aux.TRUE,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,10,nil)
	e:SetLabel(g:GetCount()*500)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	Duel.Release(g,REASON_COST)
end
function c23150.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
	e:SetLabel(0)
end
function c23150.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

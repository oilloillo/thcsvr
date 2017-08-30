--满月的幽鬼✿魂魄妖梦
function c20238.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,20238)
	e1:SetCondition(c20238.spcon)
	e1:SetOperation(c20238.spop)
	c:RegisterEffect(e1)
	--summon,flip,special
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c20238.retreg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--field
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c20238.fcon)
	e5:SetTarget(c20238.ftg)
	e5:SetOperation(c20238.fop)
	c:RegisterEffect(e5)
end
function c20238.spfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c20238.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnCount()<=6
		and Duel.IsExistingMatchingCard(c20238.spfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c20238.spfilter,tp,LOCATION_DECK,0,1,nil)
end
function c20238.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c20238.spfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c20238.spfilter,tp,LOCATION_DECK,0,nil)
	local sg=g1:RandomSelect(tp,1)
	local sg2=g2:RandomSelect(tp,1)
	sg:Merge(sg2)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetValue(c:GetAttack()/2)
	c:RegisterEffect(e1)
end
function c20238.fcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==re:GetHandler()
end
function c20238.filter(c)
	return c:IsSetCard(0x201) and c:IsAbleToHand()
end
function c20238.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,20046,0x208,0x4011,100,0,1,RACE_ZOMBIE,ATTRIBUTE_WIND))
		or Duel.IsExistingMatchingCard(c20238.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c20238.fop(e,tp,eg,ep,ev,re,r,rp)
	local c1=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,20046,0x208,0x4011,100,0,1,RACE_ZOMBIE,ATTRIBUTE_WIND)
	local c2=Duel.IsExistingMatchingCard(c20238.filter,tp,LOCATION_DECK,0,1,nil)
	if not c1 and not c2 then return end
	local opt=2
	if c1 then opt=0 end
	if c2 then opt=1 end
	if c1 and c2 then opt=Duel.SelectOption(tp,aux.Stringid(20238,0),aux.Stringid(20238,1)) end
	if opt==0 then
		for i=1,2 do
			local token=Duel.CreateToken(tp,20046)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCondition(c20238.con)
		e1:SetValue(c20238.efilter)
		--e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c20238.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		--e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(1,0)
		e2:SetCondition(c20238.con)
		e2:SetTarget(c20238.splimit)
		Duel.RegisterEffect(e2,tp)
	end
end
function c20238.efilter(e,re,tp)
	return re:GetHandler():IsType(TYPE_EQUIP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c20238.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()<=12
end
function c20238.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_TOKEN)
end
function c20238.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(20235,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c20238.retcon)
	e1:SetTarget(c20238.rettg)
	e1:SetOperation(c20238.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c20238.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c20238.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c20238.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

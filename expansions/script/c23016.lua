 
--风雨之鸦-射命丸 文
function c23016.initial_effect(c)
    --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c23016.op)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23016,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c23016.condition)
	e2:SetTarget(c23016.target)
	e2:SetOperation(c23016.operation)
	c:RegisterEffect(e2)
	--direct atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23016,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c23016.atkcon)
	e3:SetCost(c23016.atkcost)
	e3:SetTarget(c23016.atktg)
	e3:SetOperation(c23016.atkop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(23016,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCondition(c23016.spcon)
	e4:SetTarget(c23016.sptg)
	e4:SetOperation(c23016.spop)
	c:RegisterEffect(e4)
	--synchro summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(c23016.synlimit)
	c:RegisterEffect(e5)
end
function c23016.synlimit(e,c)
	if not c then return false end
	if c:IsSetCard(0x5208) then
	return else return not c:IsSetCard(0x120) end
end
function c23016.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c23016.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c23016.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:GetHandler():IsType(TYPE_MONSTER)
end
function c23016.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c23016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:GetLocation()==LOCATION_MZONE and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c23016.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
function c23016.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c23016.rfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c23016.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23016.rfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23016.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c23016.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_DIRECT_ATTACK)==0 end
end
function c23016.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c23016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c23016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c23016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1900)
		c:RegisterEffect(e1)
	end
end

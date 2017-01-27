--红之自警队✿藤原妹红
function c21094.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21094,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c21094.ntcon)
	e1:SetOperation(c21094.ntop)
	c:RegisterEffect(e1)
	--atk→
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21094,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c21094.atkcon)
	e2:SetTarget(c21094.atktg)
	e2:SetOperation(c21094.atkop)
	c:RegisterEffect(e2)
end
function c21094.ntfilter(c)
	return c:IsSetCard(0x137) and c:IsAbleToGrave()
end
function c21094.ntcon(e,c)
	if c==nil then return true end
	return c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21094.ntfilter,c:GetControler(),LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c21094.ntfilter,c:GetControler(),LOCATION_DECK,0,1,c)
end
function c21094.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c21094.ntfilter,c:GetControler(),LOCATION_HAND,0,1,1,c)
	local g2=Duel.SelectMatchingCard(tp,c21094.ntfilter,c:GetControler(),LOCATION_DECK,0,1,1,c)
	g:Merge(g2)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c21094.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_DECK)
end
function c21094.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c21094.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21094.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21094.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c21094.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21094.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
		tc:RegisterEffect(e2)
	end
end

--咒✿键山雏
function c23076.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c23076.spcon)
	e1:SetOperation(c23076.spop)
	c:RegisterEffect(e1)
	--deck destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23076,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c23076.target)
	e2:SetOperation(c23076.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23076,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c23076.thtg)
	e3:SetOperation(c23076.thop)
	c:RegisterEffect(e3)
end
function c23076.spfilter(c)
	return c:IsSetCard(0x113) and (c:IsAbleToDeckAsCost() or c:IsAbleToRemoveAsCost())
		and (c:GetPreviousLocation()==LOCATION_DECK or c:GetPreviousLocation()==LOCATION_EXTRA or c:GetReason()==REASON_MATERIAL+REASON_SYNCHRO)
end
function c23076.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c23076.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c23076.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23076.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,tp,1,REASON_COST)
	local rg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if rg:GetCount()>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function c23076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,tp,1)
end
function c23076.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
function c23076.filter(c)
	return c:IsSetCard(0x113) and c:IsAbleToHand()
end
function c23076.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RETURN)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c23076.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.HintSelection(tc)
	local code=tc:GetFirst():GetCode()
	e:SetLabel(code)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c23076.damcon)
	e2:SetOperation(c23076.damop)
	e2:SetLabelObject(e)
	Duel.RegisterEffect(e2,tp)
end
function c23076.damcon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabelObject():GetLabel()
	local tc=eg:GetFirst()
	return tc:GetPreviousLocation()==LOCATION_DECK and tc:GetCode()==code and tc:GetPreviousControler()==1-tp
end
function c23076.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end

--白色少女✿爱莲
function c13081.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),4,2)
	c:EnableReviveLimit()
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13021,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c13081.target)
	e5:SetOperation(c13081.operation)
	c:RegisterEffect(e5)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13021,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c13081.spcon)
	e1:SetCost(c13081.cost)
	e1:SetTarget(c13081.sptg)
	e1:SetOperation(c13081.spop)
	c:RegisterEffect(e1)
end
function c13081.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13081.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c13081.desfilter(chkc) end
	if chk==0 then return e:GetHandler():GetOverlayCount()>0
		and Duel.IsExistingTarget(c13081.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c13081.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13081.spfilter(c,e,tp)
	return c:IsCode(13005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13081.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p=tc:GetControler()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 and p==tp then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c13081.spfilter,tp,0x13,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_ADD_TYPE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(TYPE_TUNER)
				g:GetFirst():RegisterEffect(e1)
				Duel.SpecialSummonComplete()
			end
		end
	end
end
function c13081.filter(c,tp)
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsPreviousLocation(LOCATION_SZONE))
end
function c13081.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13081.filter,1,nil,tp)
end
function c13081.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c13081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13081.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

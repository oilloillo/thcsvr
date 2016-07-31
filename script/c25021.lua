 
--月光妖精 露娜·查尔德
function c25021.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25021,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c25021.descon)
	e1:SetTarget(c25021.destg)
	e1:SetOperation(c25021.desop)
	c:RegisterEffect(e1)
	--deck destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25021,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c25021.target)
	e2:SetOperation(c25021.operation)
	c:RegisterEffect(e2)
end
function c25021.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>2
end
function c25021.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c25021.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
function c25021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
end
function c25021.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,4,REASON_EFFECT)
end

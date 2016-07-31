 
--废狱「被厌恶者的Philosophy」
function c24039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetCondition(c24039.condition)
	e1:SetTarget(c24039.target)
	e1:SetOperation(c24039.operation)
	c:RegisterEffect(e1)
end
function c24039.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x625)
end
function c24039.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24039.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c24039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
function c24039.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	else
		Duel.ShuffleHand(1-tp)
	end
end

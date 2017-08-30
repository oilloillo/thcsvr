--红魔✿不动的大图书馆
function c22204.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22204,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c22204.settg)
	e1:SetOperation(c22204.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
end
function c22204.filter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c22204.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c22204.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c22204.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22204.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end

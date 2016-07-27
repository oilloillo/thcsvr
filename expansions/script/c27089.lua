--天符『天之磐舟』
function c27089.initial_effect(c)
	aux.AddRitualProcGreater(c,aux.FilterBoolFunction(c27089.rifilter))
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27089,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,27089)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c27089.spcon)
	e1:SetCost(c27089.cost)
	e1:SetTarget(c27089.sptg)
	e1:SetOperation(c27089.spop)
	c:RegisterEffect(e1)
end
function c27089.rifilter(c)
	return c:GetLevel()==5 and c:IsSetCard(0x208) and c:IsRace(RACE_ZOMBIE) and bit.band(c:GetType(),0x81)==0x81
end
function c27089.gfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x208)
end
function c27089.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27089.gfilter,1,nil)
end
function c27089.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c27089.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c27089.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27089,1))
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end

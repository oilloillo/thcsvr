--天符『雨之磐舟』
function c27088.initial_effect(c)
	aux.AddRitualProcGreater(c,aux.FilterBoolFunction(c27088.rifilter))
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27088,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,27088)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c27088.spcon)
	e1:SetCost(c27088.cost)
	e1:SetTarget(c27088.sptg)
	e1:SetOperation(c27088.spop)
	c:RegisterEffect(e1)
end
function c27088.rifilter(c)
	return c:GetLevel()==5 and c:IsSetCard(0x208) and c:IsRace(RACE_ZOMBIE) and bit.band(c:GetType(),0x81)==0x81
end
function c27088.gfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_RITUAL and c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x208)
end
function c27088.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27088.gfilter,1,nil)
end
function c27088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c27088.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c27088.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

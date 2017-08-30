--超越时空的折凳使✿北白河千百合
function c13068.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c13068.spcon)
	e1:SetOperation(c13068.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13068,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c13068.target)
	e2:SetOperation(c13068.operation)
	c:RegisterEffect(e2)
end
function c13068.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==Duel.GetFieldGroupCount(c:GetControler(),LOCATION_SZONE,0,nil)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_SZONE,0,nil)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c13068.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c13068.tfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x13d)
end
function c13068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13068.tfilter,tp,0x1e,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x1e)
end
function c13068.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c13068.tfilter,tp,0x1e,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end

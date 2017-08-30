 
--天龙型轻巡洋舰-天龙
function c50078.initial_effect(c)
	local temp = 0
	while temp<4 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50078,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50078.negcon)
	e2:SetCost(c50078.negcost)
	e2:SetTarget(c50078.negtg)
	e2:SetOperation(c50078.negop)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50078,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c50078.sumtg)
	e3:SetOperation(c50078.sumop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
end
function c50078.tfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x4bb)
end
function c50078.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g:IsExists(c50078.tfilter,1,nil)
end
function c50078.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c50078.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c50078.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c50078.filter(c,e,tp)
	return c:IsSetCard(0x54bb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50078.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50078.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c50078.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50078.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

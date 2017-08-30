--浅葱色的月兔✿清兰
function c31001.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c31001.sdcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_STANDBY_PHASE,TIMING_STANDBY_PHASE)
	e2:SetTarget(c31001.sptg)
	e2:SetOperation(c31001.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31001,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,31001)
	e3:SetCost(c31001.cost)
	e3:SetTarget(c31001.target)
	e3:SetOperation(c31001.operation)
	c:RegisterEffect(e3)
end

c31001.DescSetName=0x258

function c31001.sdcon(e)
	return e:GetHandler():GetAttack()>e:GetHandler():GetBaseAttack()
end
function c31001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetCurrentPhase()==PHASE_STANDBY end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c31001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e1)
	end
end
function c31001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c31001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsDestructable() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c31001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

 
--雪
function c15010.initial_effect(c)
	--immune effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c15010.indcon)
	e1:SetValue(c15010.efilter)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15010,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c15010.cost)
	e2:SetTarget(c15010.destg)
	e2:SetOperation(c15010.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(15010,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c15010.spcon)
	e4:SetCost(c15010.cost)
	e4:SetTarget(c15010.sptg)
	e4:SetOperation(c15010.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e5)
end
function c15010.infilter(c)
	return c:IsSetCard(0x150) and c:IsFaceup()
end
function c15010.indcon(e)
	return Duel.IsExistingMatchingCard(c15010.infilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c15010.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
function c15010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15010.filter(c)
	return not c:IsType(TYPE_RITUAL) and not c:IsType(TYPE_XYZ) and c:IsDestructable() and c:IsFaceup()
end
function c15010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c15010.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c15010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c15010.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c15010.spfilter(c,tp)
	return c:IsCode(15013) and c:GetPreviousControler()==tp
end
function c15010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c15010.spfilter,1,nil,tp)
end
function c15010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c15010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e1)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

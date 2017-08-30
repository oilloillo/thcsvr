 
--魔界女仆 梦子
function c15016.initial_effect(c)
	--immune effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c15016.indcon)
	e1:SetValue(c15016.efilter)
	c:RegisterEffect(e1)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15016,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c15016.cost)
	e2:SetTarget(c15016.thtg)
	e2:SetOperation(c15016.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(15016,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c15016.spcon)
	e4:SetCost(c15016.cost)
	e4:SetTarget(c15016.sptg)
	e4:SetOperation(c15016.spop)
	c:RegisterEffect(e4)
end
function c15016.infilter(c)
	return c:IsSetCard(0x150) and c:IsFaceup()
end
function c15016.indcon(e)
	return Duel.IsExistingMatchingCard(c15016.infilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c15016.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
function c15016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15016.tgfilter(c)
	return c:IsSetCard(0x150) and c:IsAbleToHand()-- and not c:IsCode(15016)
end
function c15016.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:GetControler()==tp and c15016.tgfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c15016.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c15016.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c15016.spfilter(c)
	return c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER)
end
function c15016.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15016.spfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil and ct>2
end
function c15016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c15016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

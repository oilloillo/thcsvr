--槐安之梦✿冈崎梦美
function c13070.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13070,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,13070)
	e1:SetCondition(c13070.condition)
	e1:SetTarget(c13070.target)
	e1:SetOperation(c13070.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13070,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,13071)
	e3:SetCondition(c13070.setcon)
	e3:SetTarget(c13070.settg)
	e3:SetOperation(c13070.setop)
	c:RegisterEffect(e3)
	--only 1 can exists
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e10:SetCondition(c13070.excon)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_MZONE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetTargetRange(1,0)
	e12:SetCode(EFFECT_CANNOT_SUMMON)
	e12:SetTarget(c13070.sumlimit)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e13)
	local e14=e12:Clone()
	e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e14)
	--selfdes
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_SELF_DESTROY)
	e15:SetRange(LOCATION_MZONE)
	e15:SetTargetRange(LOCATION_MZONE,0)
	e15:SetTarget(c13070.destarget)
	c:RegisterEffect(e15)
end
function c13070.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c13070.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c13070.desfilter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c13070.desfilter,tp,0xe,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c13070.desfilter,tp,0xe,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function c13070.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.GetTurnPlayer()==tp and c:IsRelateToEffect(e) then
			if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e1)
			end
		end
	end
end
function c13070.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c13070.sfilter(c)
	return c:IsSetCard(0x13e) and c:IsSSetable()
end
function c13070.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c13070.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c13070.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c13070.sumlimit(e,c)
	return c:IsSetCard(0x13d)
end
function c13070.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13d)
end
function c13070.excon(e)
	return Duel.IsExistingMatchingCard(c13070.exfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c13070.destarget(e,c)
	return c:IsSetCard(0x13d) and c:GetFieldID()>e:GetHandler():GetFieldID()
end

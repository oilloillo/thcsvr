 
--绯想✿西行寺幽幽子
function c200008.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(20032)
	c:RegisterEffect(e1)
	--synchro summon
	aux.AddSynchroProcedure(c,c200008.synfilter,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c200008.fcon)
	e4:SetOperation(c200008.fop)
	c:RegisterEffect(e4)
	--stg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200008,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c200008.stg)
	e2:SetOperation(c200008.sop)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,200008)
	e2:SetTarget(c200008.sptg)
	e2:SetOperation(c200008.spop)
	c:RegisterEffect(e2)
	--to extra
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_REPEAT)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetOperation(c200008.op2)
	c:RegisterEffect(e5)
end
function c200008.synfilter(c)
	local x=c:GetOriginalCode()
	return x>=200001 and x<=200020
end
function c200008.fcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c200008.fop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200108)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200008.filter(c)
	return c:IsAbleToGrave() and c:IsFaceup()
end
function c200008.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c200008.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c200008.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c200008.sop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(c200008.damval)
			e1:SetReset(RESET_PHASE+PHASE_END,1)
--			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c200008.damval(e,re,val,r,rp,rc)
	return val/2
end
function c200008.spfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c200008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	if chk==0 then return c:GetSummonType()==SUMMON_TYPE_SYNCHRO
		and ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and mg:FilterCount(c200008.spfilter,nil,e,tp,c)==ct end
	Duel.SetTargetCard(mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,ct,0,0)
end
function c200008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=mg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<mg:GetCount() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(-500)
--		tc:RegisterEffect(e2)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(-500)
--		tc:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c200008.filter2(c)
	return c:IsCode(200208) and c:IsAbleToHand()
end
function c200008.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c200008.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(200008,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200008.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end
end
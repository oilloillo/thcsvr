--毘沙门天的弟子✿寅丸星
function c26113.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SetCard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e1:SetValue(0x251)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26113.sccon)
	e2:SetTarget(c26113.splimit)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26113,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26113.target)
	e3:SetOperation(c26113.operation)
	c:RegisterEffect(e3)
	--scale up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26113,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c26113.sucon)
	e4:SetOperation(c26113.suop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26113,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1,26113)
	e5:SetCode(EVENT_CHANGE_POS)
	e5:SetCondition(c26113.spcon)
	e5:SetTarget(c26113.sptg)
	e5:SetOperation(c26113.spop)
	c:RegisterEffect(e5)
	--threeeeeeee in 1
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26113,3))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,261130)
	e6:SetTarget(c26113.threetg)
	e6:SetOperation(c26113.threeop)
	c:RegisterEffect(e6)
end
function c26113.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or tc:GetOriginalAttribute()==e:GetHandler():GetOriginalAttribute()
end
function c26113.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c26113.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c26113.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26113.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26113.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26113.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26113.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c26113.sucon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x251)
end
function c26113.suop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=c:GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(3)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	if tc then
		local e3=e1:Clone()
		tc:RegisterEffect(e3)
		local e4=e2:Clone()
		tc:RegisterEffect(e4)
	end
end
function c26113.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x251)
end
function c26113.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26113.cfilter,1,nil,tp)
end
function c26113.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsFaceup()
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26113.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26113.threefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x251)
end
function c26113.threetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26113.threefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26113.threefilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26113.threefilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local t={}
	local p=1
	if tc:GetLevel()>1 then t[p]=aux.Stringid(26113,5) p=p+1 end
	if tc:GetLevel()>0 then t[p]=aux.Stringid(26113,6) p=p+1 end
	if tc:IsAbleToHand() and Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)>0 then t[p]=aux.Stringid(26113,7) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26113,4))
	local opt=Duel.SelectOption(tp,table.unpack(t))
	if opt==2 then e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
	e:SetLabel(opt)
end
function c26113.threeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local opt=e:GetLabel()
	if not tc:IsRelateToEffect(e) then return end
	if opt==2 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		if g:GetCount()>0 then
			local tg=g:GetMaxGroup(Card.GetSequence)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	elseif tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if opt==0 then
			e1:SetValue(-2)
		else
			e1:SetValue(2)
		end
		tc:RegisterEffect(e1)
	end
end

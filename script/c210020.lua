--奇异的仙人✿茨木华扇
function c210020.initial_effect(c)
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetCondition(c210020.limcon)
	c:RegisterEffect(e0)
	if not c210020.global_check then
		c210020.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c210020.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210020,4))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x3b)
	e1:SetTarget(c210020.sptg)
	e1:SetOperation(c210020.spop)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210020,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c210020.descon)
	e2:SetTarget(c210020.destg)
	e2:SetOperation(c210020.desop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--skip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(210020,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c210020.skcon)
	e3:SetTarget(c210020.sktg)
	e3:SetOperation(c210020.skop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--adup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(210020,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c210020.adcon)
	e4:SetTarget(c210020.adtg)
	e4:SetOperation(c210020.adop)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
	--th
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(210020,3))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c210020.thcon)
	e5:SetTarget(c210020.thtg)
	e5:SetOperation(c210020.thop)
	e5:SetLabelObject(e1)
	c:RegisterEffect(e5)
end
function c210020.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsCode(210020) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,210020,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,210020,RESET_PHASE+PHASE_END,0,1) end
end
function c210020.limcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),210020)~=0
end
function c210020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c210020.spfilter,c:GetControler(),LOCATION_ONFIELD,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c210020.spfilter(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToGrave() and c:IsFaceup()
end
function c210020.gfilter(c,g1)
	return not g1:IsContains(c)
end
function c210020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local m=Duel.GetMatchingGroupCount(c210020.spfilter,tp,LOCATION_ONFIELD,0,nil)
	if m<3 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c210020.spfilter,tp,LOCATION_ONFIELD,0,3,m,nil)
	local g1=g:Filter(Card.IsSetCard,nil,0x710)
	local g2=g:Filter(c210020.gfilter,nil,g1)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	local tc=g:GetFirst()
	local tpe=0
	while tc do
		tpe=bit.bor(tpe,tc:GetOriginalType())
		tc=g:GetNext()
	end
	e:SetLabel(tpe)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(g:GetCount()*500)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(g:GetCount()*500)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	--damage reduce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCondition(c210020.rdcon)
	e1:SetOperation(c210020.rdop)
	c:RegisterEffect(e1)
end
function c210020.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c210020.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c210020.descon(e,tp,eg,ep,ev,re,r,rp)
	return re and re==e:GetLabelObject() and bit.band(e:GetLabelObject():GetLabel(),TYPE_FUSION)~=0
end
function c210020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function c210020.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then 
	Duel.HintSelection(g)
	Duel.Destroy(tc,REASON_EFFECT) 
	end
end
function c210020.skcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re==e:GetLabelObject() and bit.band(e:GetLabelObject():GetLabel(),TYPE_SYNCHRO)~=0
end
function c210020.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c210020.skop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_M1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c210020.adcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re==e:GetLabelObject() and bit.band(e:GetLabelObject():GetLabel(),TYPE_XYZ)~=0
end
function c210020.adfilter(c)
	return c:IsSetCard(0x710) and (not c:IsLocation(LOCATION_EXTRA) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())) and c:IsAbleToHand()
end
function c210020.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210020.adfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function c210020.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c210020.adfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
function c210020.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re==e:GetLabelObject() and bit.band(e:GetLabelObject():GetLabel(),TYPE_PENDULUM)~=0
end
function c210020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c210020.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
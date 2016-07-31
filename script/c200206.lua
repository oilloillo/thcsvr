 
--符器-西洋魔法书
function c200206.initial_effect(c)
	c:SetUniqueOnField(1,0,200206)
	c:EnableCounterPermit(0x700)
	c:SetCounterLimit(0x700,10)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--des
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200206,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c200206.con)
	e1:SetOperation(c200206.op)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c200206.ctcon)
	e2:SetOperation(c200206.ctop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c200206.atktg)
	e3:SetValue(c200206.atkval)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c200206.thcon)
	e4:SetTarget(c200206.thtg)
	e4:SetOperation(c200206.thop)
	c:RegisterEffect(e4)
end
function c200206.con(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x700)
	return Duel.GetCounter(tp,1,0,0x700)>ct
end
function c200206.damfilter(c)
	return c:GetCounter(0x700)>0
end
function c200206.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local ct=e:GetHandler():GetCounter(0x700)
	if e:GetHandler():IsFaceup() and Duel.GetCounter(tp,1,0,0x700)>ct then
		local g=Duel.GetMatchingGroup(c200206.damfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
		local tc=g:GetFirst()
		local sum=0
		while tc do
			local sct=tc:GetCounter(0x700)
			tc:RemoveCounter(tp,0x700,sct,0)
			sum=sum+sct
			tc=g:GetNext()
		end
		if ct+sum>10 then sum=10-ct end
		e:GetHandler():AddCounter(0x700,sum)
	end
end
function c200206.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	return e:GetHandler()~=re:GetHandler() and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:GetHandlerPlayer()==tp
end
function c200206.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x700,1)
end
function c200206.atktg(e,c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c200206.atkval(e,c)
	return e:GetHandler():GetCounter(0x700)*100
end
function c200206.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x700)
	e:SetLabel(ct)
	return ct>=5 and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_DESTROY)
end
function c200206.filter(c,lv)
	return c:IsLevelBelow(5) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand() and c:IsSetCard(0x208)
end
function c200206.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c200206.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c200206.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
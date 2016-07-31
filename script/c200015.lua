 
--绯想✿比那名居天子
function c200015.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,200015)
	e1:SetCondition(c200015.spcon)
	c:RegisterEffect(e1)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200015,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c200015.target)
	e1:SetOperation(c200015.activate)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c200015.condition)
	e3:SetCountLimit(1,2000015)
--	e3:SetCost(c200015.cost2)
	e3:SetTarget(c200015.tg2)
	e3:SetOperation(c200015.op2)
	c:RegisterEffect(e3)
end
function c200015.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x701)
end
function c200015.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c200015.spfilter,c:GetControler(),LOCATION_SZONE,0,1,nil) 
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c200015.filter(x)
	return x>=200101 and x<=200120
end
function c200015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	local ct=1
	while not c200015.filter(ac) and ct<5 do
	Duel.SelectOption(tp,aux.Stringid(200015,1))
	Duel.Hint(HINT_SELECTMSG,tp,0)
	ac=Duel.AnnounceCard(tp)
	if ac>=200501 and ac<=200520 then ac=ac-400 end
	ct=ct+1
	end
	if not c200015.filter(ac) and ct==5 then ac=math.random(200101,200120) end
	e:SetLabel(ac)
end
function c200015.activate(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,e:GetLabel())
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)
	Duel.RaiseEvent(token,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
	Duel.ConfirmCards(1-tp,token)
	if token:IsCode(200103) then token:RegisterFlagEffect(200103,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) end
end
function c200015.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c200015.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,200015)<=0 end
	Duel.RegisterFlagEffect(tp,200015,RESET_PHASE+PHASE_END,0,1)
end
function c200015.filter2(c)
	return c:IsCode(200215) and c:IsAbleToHand()
end
function c200015.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200015.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c200015.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200015.filter2,tp,LOCATION_DECK,0,1,nil) then 
		local tc=Duel.GetFirstMatchingCard(c200015.filter2,tp,LOCATION_DECK,0,nil)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
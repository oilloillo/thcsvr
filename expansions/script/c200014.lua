 
--绯想✿永江衣玖
function c200014.initial_effect(c)
	--reflect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c200014.op1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCost(c200014.cost2)
	e1:SetCountLimit(1,200014)
	e1:SetTarget(c200014.tg2)
	e1:SetOperation(c200014.op2)
	c:RegisterEffect(e1)
end
function c200014.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200114)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200014.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,200014)==0 end
	Duel.RegisterFlagEffect(tp,200014,RESET_PHASE+PHASE_END,0,1)
end
function c200014.filter(c)
	return (c:IsCode(200214) or c:IsCode(200015)) and c:IsAbleToHand()
end
function c200014.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200014.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c200014.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200014.filter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200014.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)	
	end
end
 
--秘封梦想家 梅莉
function c28007.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28007,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c28007.shcon)
	e1:SetTarget(c28007.shtg)
	e1:SetOperation(c28007.shop)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	--damage zero
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28007,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetCondition(c28007.btcon)
	e2:SetCost(c28007.btcost)
	e2:SetOperation(c28007.btop)
	c:RegisterEffect(e2)
end
function c28007.shcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function c28007.thfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c28007.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28007.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28007.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c28007.btcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=Duel.GetAttacker()
	if bt and bt:IsSetCard(0x211) and bt:IsControler(tp) then return true end
	bt=Duel.GetAttackTarget()
	return bt and bt:IsSetCard(0x211)  and bt:IsControler(tp) and Duel.GetBattleDamage(tp)>0
end
function c28007.costfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function c28007.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28007.costfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28007.costfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c28007.btop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c28007.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c28007.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end


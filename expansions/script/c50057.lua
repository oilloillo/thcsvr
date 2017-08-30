 
--金刚型高速战舰-金刚
function c50057.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x4bb),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50057,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c50057.eqtg2)
	e2:SetOperation(c50057.eqop2)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50057,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c50057.cost3)
	e3:SetTarget(c50057.tg3)
	e3:SetOperation(c50057.op3)
	c:RegisterEffect(e3)
	--disable attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50057,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c50057.condition4)
	e4:SetCost(c50057.cost4)
	e4:SetTarget(c50057.target4)
	e4:SetOperation(c50057.operation4)
	c:RegisterEffect(e4)
	--attack cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetCost(c50057.atcost5)
	e5:SetOperation(c50057.atop5)
	c:RegisterEffect(e5)
end
function c50057.filter2(c)
	return c:IsCode(50807)
end
function c50057.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c50057.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
end
function c50057.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c50057.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c50057.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c50057.filter3(c)
	return c:IsSetCard(0x4bb) and c:IsAbleToHand()
end
function c50057.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50057.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50057.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50057.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c50057.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()==nil
end
function c50057.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c50057.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c50057.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c50057.atcost5(e,c,tp)
	return Duel.CheckLPCost(tp,600)
end
function c50057.atop5(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,600)
end
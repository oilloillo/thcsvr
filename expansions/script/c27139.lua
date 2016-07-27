--原始呐喊✿幽谷响子
function c27139.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27139,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c27139.cost)
	e2:SetTarget(c27139.target)
	e2:SetOperation(c27139.operation)
	c:RegisterEffect(e2)
	--th
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(27139,1))
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c27139.thtg)
	e3:SetOperation(c27139.thop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(27139,2))
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,27139)
	e4:SetCondition(c27139.scrcon)
	e4:SetTarget(c27139.sctg)
	e4:SetOperation(c27139.scop)
	c:RegisterEffect(e4)
	--atkchange
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(27139,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCondition(c27139.atkcon)
	e5:SetOperation(c27139.atkop)
	c:RegisterEffect(e5)
end
function c27139.rfilter(c)
	return c:IsSetCard(0x208) and c:IsLocation(LOCATION_HAND)
end
function c27139.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c27139.rfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c27139.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c27139.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=8000 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c27139.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c27139.filter2(c)
	return c:IsSetCard(0x527) and c:IsPreviousLocation(LOCATION_HAND) and c:GetTurnID()==Duel.GetTurnCount() and c:IsAbleToHand()
end
function c27139.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c27139.filter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function c27139.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c27139.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c27139.scrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c27139.filter3(c)
	return c:IsSetCard(0x522) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c27139.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27139.filter3,tp,LOCATION_DECK,0,1,nil) end
end
function c27139.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c27139.filter3,tp,LOCATION_DECK,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,c27139.filter3,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)	
	end
end
function c27139.filter(c,tc)
	if not c:IsFaceup() then return false end
	return tc:GetBaseAttack()~=c:GetAttack() or tc:GetBaseAttack()~=c:GetDefence()
end
function c27139.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and c27139.filter(c,bc) and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c27139.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(bc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

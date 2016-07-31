--雷电轰鸣的神灵✿苏我屠自古
--require "expansions/nef/nef"
function c27073.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	local argTable = {TYPE_RITUAL,0x208}
	Nef.EnablePendulumAttributeSP(c,5,c27073.pendFilter,argTable,false,"GodSprite")
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27073,0))
	e2:SetCategory(CATEGORY_TO_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c27073.cost)
	e2:SetTarget(c27073.target)
	e2:SetOperation(c27073.operation)
	c:RegisterEffect(e2)
	--hand des
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27073,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,27073)
	e3:SetCondition(c27073.rcon)
	e3:SetTarget(c27073.rtg)
	e3:SetOperation(c27073.rop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27073,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,270730)
	e4:SetCondition(c27073.pcon)
	e4:SetTarget(c27073.ptg)
	e4:SetOperation(c27073.pop)
	c:RegisterEffect(e4)
end
function c27073.pendFilter(c, ctype, setname)
	return c:IsType(ctype) and c:IsSetCard(setname)
end
function c27073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c27073.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x912) and not c:IsCode(27073) and c:IsAbleToGrave()
end
function c27073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27073.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TO_GRAVE,nil,1,tp,LOCATION_DECK)
end
function c27073.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c27073.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c27073.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c27073.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c27073.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,200,REASON_EFFECT)
	end
end
function c27073.pcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c27073.pfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c27073.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27073.pfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c27073.pfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c27073.pop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27073.pfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMinGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end

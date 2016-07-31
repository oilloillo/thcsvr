--三种神器之　镜
--require "expansions/nef/nef"
function c999203.initial_effect(c)
	--pendulum summon
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,1,aux.TRUE,argTable,false)
	--Dual
	Nef.EnableDualAttribute(c, TYPE_PENDULUM)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--mamo
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e2:SetCondition(c999203.mamocon)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c999203.mamotarget)
	e2:SetValue(c999203.mamoval)
	c:RegisterEffect(e2)
	--be attacked
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999203,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCountLimit(1,999203)
	e3:SetCondition(aux.IsDualState)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c999203.destg)
	e3:SetOperation(c999203.desop)
	c:RegisterEffect(e3)
	--become effect target
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999203,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,999203)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetCondition(c999203.descon)
	e4:SetTarget(c999203.destg)
	e4:SetOperation(c999203.desop)
	c:RegisterEffect(e4)
end
function c999203.filter(c)
	return c:IsCode(999204) and not c:IsDisabled()
end
function c999203.mamocon(e)
	local c = e:GetHandler()
	local tp = c:GetControler()
	return c:GetSequence()==6 or c:GetSequence()==7 
		or Duel.IsExistingMatchingCard(c999203.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c999203.mamotarget(e,c)
	return c:IsSetCard(0xaa1) and not c:IsCode(999203)
end
function c999203.mamoval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c999203.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c) and c:IsDualState()
end
function c999203.desfilter(c,tc)
	return c==tc
end
function c999203.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1 = Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2 = Duel.SelectTarget(tp,c999203.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,c)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
end
function c999203.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
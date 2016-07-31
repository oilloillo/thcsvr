 
--妖魔书-一时的七大奇迹
function c21470010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetDescription(aux.Stringid(21470010,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCost(c21470010.cost)
--	e1:SetTarget(c21470010.target)
	e1:SetOperation(c21470010.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetDescription(aux.Stringid(21470010,1))
	e2:SetOperation(c21470010.activate2)
	c:RegisterEffect(e2)
end--[[
function c21470010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end]]
function c21470010.tg(e,c)
	return c:IsSetCard(0x742) and c:IsFaceup()
end
function c21470010.tg2(e,c)
	return c:IsSetCard(0x742) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
	--return c:IsCode(e:GetLabel())
end
function c21470010.filter(c)
--	return x==21470002 or (x>=21470005 and x<=21470010) or (x>=21470012 and x<=21470017) or x==21470022
	return c:IsFacedown() or c:IsPosition(POS_FACEUP_DEFENCE)
end
function c21470010.target(e,tp,eg,ep,ev,re,r,rp,chk)--[[
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	while not c21470010.filter(ac) do
	Duel.SelectOption(tp,21470010*16+1)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	ac=Duel.AnnounceCard(tp)
	end
	e:SetLabel(ac)]]
	if chk==0 then return Duel.IsExistingMatchingCard(c21470010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	if Duel.IsExistingMatchingCard(c21470010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		local g=Duel.GetMatchingGroup(c21470010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	end
end
function c21470010.activate(e,tp,eg,ep,ev,re,r,rp)--[[
	local g=Duel.GetMatchingGroup(c21470010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then Duel.ChangePosition(g,0x1,0x1,0x1,0x1,true) end]]
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
--	e1:SetLabel(e:GetLabel())
	e1:SetTarget(c21470010.tg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c21470010.tg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(700)
	Duel.RegisterEffect(e2,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetTarget(c21470010.tg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(700)
	Duel.RegisterEffect(e2,tp)--[[
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTarget(c21470010.tg2)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetValue(c21470010.ifilter)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)]]
end
function c21470010.ifilter(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c21470010.activate2(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c21470010.discon)
	e2:SetOperation(c21470010.disop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c21470010.disfilter(c)
	return c:IsSetCard(0x742) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c21470010.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c21470010.disfilter,1,nil) and ep~=tp
end
function c21470010.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
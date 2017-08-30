 
--妖魔书-大魔导书
function c21470009.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCost(c21470009.cost)
	e1:SetTarget(c21470009.damtg)
	e1:SetOperation(c21470009.damop)
	c:RegisterEffect(e1)
end--[[
function c21470009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21470009)<=0 end
	Duel.RegisterFlagEffect(tp,21470009,RESET_PHASE+PHASE_END,0,1)
end]]
function c21470009.cfilter(c)
	return c:IsSetCard(0x742)
end
function c21470009.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=Duel.GetMatchingGroupCount(c21470009.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return gc>0
--	and not e:GetHandler():IsStatus(STATUS_SET_TURN)
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(gc*300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,gc*300)
end
function c21470009.damop(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetMatchingGroupCount(c21470009.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Damage(1-tp,gc*300,REASON_EFFECT)
end

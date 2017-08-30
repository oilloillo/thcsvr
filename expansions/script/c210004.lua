--茨华仙宠✿竿打
function c210004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c210004.splimit)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(210004,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,210004)
	e3:SetCost(c210004.dcost)
	e3:SetTarget(c210004.dtg)
	e3:SetOperation(c210004.dop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(210004,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,210004)
	e4:SetTarget(c210004.dtg)
	e4:SetOperation(c210004.op)
	c:RegisterEffect(e4)
end
function c210004.splimit(e,c,tp,sumtp,sumpos)
--[[
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return (not tc or not tc:IsCode(210003)) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM]]
	return not c:IsSetCard(0x710) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c210004.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c210004.filter(c)
	return c:IsSetCard(0x710) and c:IsAbleToHand()
end
function c210004.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c210004.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c210004.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
end
function c210004.con2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_OVERLAY) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
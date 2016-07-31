--百鬼夜行✿伊吹萃香
--require "expansions/nef/nef"
local M = c999719
local Mid = 999719
function M.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,nil,1)
	c:EnableReviveLimit()
	-- sp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(M.lvop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(Mid,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(M.tdcon)
	e2:SetOperation(M.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
end

function M.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function M.tdop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp, 999701)
	Duel.SendtoDeck(token, nil, 2, REASON_EFFECT)
end

function M.lvop(e,tp,eg,ep,ev,re,r,rp)
	if not Nef.skList then 
		Nef.skList = {} 
		Nef.skList[0] = {[1] = 1}
		Nef.skList[1] = {[1] = 1}
		Nef.skList.isSummon = {}
	end
	Nef.skList[tp][3] = 4
end
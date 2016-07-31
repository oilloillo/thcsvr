--三种神器　洗衣机
--require "expansions/nef/nef"
function c999209.initial_effect(c)
	--pend
	aux.EnablePendulumAttribute(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--sp summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999209,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999209.con)
	e1:SetTarget(c999209.tg)
	e1:SetOperation(c999209.op)
	c:RegisterEffect(e1)
end

function c999209.con(e)
	local c = e:GetHandler()
	return c:GetPreviousLocation() == LOCATION_EXTRA
end
function c999209.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_ONFIELD) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c999209.op(e,tp,eg,ep,ev,re,r,rp)
	-- init
	local operation = {
		[1] = function()
			Duel.Draw(tp, 1, REASON_EFFECT)
		end,
		[2] = function ()
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil) then
				Duel.ConfirmDecktop(tp, 1)
			end
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil) then
				Duel.ConfirmDecktop(1-tp, 1)
			end
		end,
		[3] = function ()
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,2,nil) then
				Duel.ShuffleDeck(tp)
			end
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,2,nil) then
				Duel.ShuffleDeck(1-tp)
			end
		end,
		[4] = function ()
			if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			end
		end,
	}

	local t = {}
	for i=1,4 do
		t[i] = {desc = aux.Stringid(999209,i), op = operation[i]}
	end
	-- process
	while #t>0 do
		local opt = Duel.SelectOption(tp, Nef.unpackOneMember(t, "desc"))+1
		t[opt].op()
		table.remove(t, opt)
	end
end
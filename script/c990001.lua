--轮抽模式
--require "expansions/nef/nef"
function c990001.initial_effect(c)
	if c990001.counter==nil then
		c990001.counter = true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetCode(EFFECT_CANNOT_ACTIVATE)
		e0:SetTargetRange(1,1)
		e0:SetValue(c990001.aclimit)
		Duel.RegisterEffect(e0,0)

		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	    e1:SetCode(EVENT_ADJUST)
	    e1:SetOperation(c990001.op)
		e1:SetLabelObject(c)
	    e1:SetLabel(990001)
	    e1:SetLabelObject(e0)
		Duel.RegisterEffect(e1,0)

		-- local e2=Effect.CreateEffect(c)
		-- e2:SetType(EFFECT_TYPE_IGNITION)
		-- e2:SetRange(LOCATION_REMOVED)
		-- e1:SetTarget(c990001.drawtg)
		-- e2:SetOperation(c990001.drawop)
		-- e2:SetLabel(990001)
		-- e2:SetLabelObject(e0)
		-- c:RegisterEffect(e2)
	end
end

function c990001.aclimit(e,re,tp)
	return Duel.GetFlagEffect(0, 990001)>0 and re:GetLabel()~=990001
end

function c990001.filter(c)
	return c:GetOriginalCode()==990001
end

function c990001.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0, 990001, 0, 0, 0)
	local flag0=Duel.IsExistingMatchingCard(c990001.filter,0,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(0, LOCATION_DECK, 0)==1
	local flag1=Duel.IsExistingMatchingCard(c990001.filter,1,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(1, LOCATION_DECK, 0)==1
	local mainNum = 40
	local exNum = 15
	if flag0 and flag1 then
		Duel.Remove(Duel.GetFieldGroup(0,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA),POS_FACEUP,REASON_RULE)
		Duel.Remove(Duel.GetFieldGroup(1,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA),POS_FACEUP,REASON_RULE)

		local player = 1
		while Duel.GetFieldGroupCount(0, LOCATION_DECK, 0)<mainNum or Duel.GetFieldGroupCount(1, LOCATION_DECK, 0)<mainNum do 
			player = 1 - player
			c990001.getCards(player, 0)
		end

		local player = 1
		while Duel.GetFieldGroupCount(0, LOCATION_EXTRA, 0)<exNum or Duel.GetFieldGroupCount(0, LOCATION_EXTRA, 0)<exNum do
			player = 1 - player
			c990001.getCards(player, 1)
		end

		Duel.ShuffleDeck(0)
		Duel.ShuffleDeck(1)

		Duel.Draw(0,2-Duel.GetFieldGroupCount(0, LOCATION_HAND, 0),REASON_RULE)
		Duel.Draw(1,2-Duel.GetFieldGroupCount(1, LOCATION_HAND, 0),REASON_RULE)
		
	end
	Duel.ResetFlagEffect(0, 990001)
	e:GetLabelObject():Reset()
	e:Reset()
end

-- function c990001.drawtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
-- 	return Duel.GetFlagEffect(0, 9900012)==0
-- end

-- function c990001.drawop(e,tp,eg,ep,ev,re,r,rp)
-- 	Duel.ResetFlagEffect(0, 990001)
-- 	Duel.RegisterFlagEffect(0, 9900012, 0, 0, 0)
-- 	Duel.Draw(0,5-Duel.GetFieldGroupCount(0, LOCATION_HAND, 0),REASON_RULE)
-- 	Duel.Draw(1,5-Duel.GetFieldGroupCount(1, LOCATION_HAND, 0),REASON_RULE)
-- 	e:GetLabelObject():Reset()
-- 	e:Reset()
-- end

function c990001.getCards(player, cardType)
	local codeList = Nef.GetRandomCardCode(8, cardType)
	local sg1 = Group.CreateGroup()
	for _,code in pairs(codeList) do
		local token=Duel.CreateToken(player,code)
		Duel.Remove(token, POS_FACEDOWN, REASON_RULE)
		sg1:AddCard(token)
	end
	local sg2=sg1:Select(player,5,5,nil)
	Duel.SendtoDeck(sg2, player, 0, REASON_RULE)
end
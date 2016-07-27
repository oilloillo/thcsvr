--醉梦『施饿鬼缚之术』
local M = c999715
local Mid = 999715
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(M.target)
	e1:SetOperation(M.operation)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e2:SetTarget(M.distg)
	c:RegisterEffect(e2)
	--cannot active
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
	-- atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabelObject(e1)
	e4:SetTargetRange(LOCATION_MZONE, 0)
	e4:SetValue(M.atkval)
	c:RegisterEffect(e4)
	-- def up
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	e5:SetValue(M.defval)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(M.descon2)
	e6:SetOperation(M.desop2)
	c:RegisterEffect(e6)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, nil) 
		and Duel.IsExistingTarget(Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp, Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, 1, nil)
	g1:Merge(g2)
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local tc=g:GetFirst()
	local sc=g:GetNext()
	if tc:GetControler()==sc:GetControler() then return end
	c:SetCardTarget(tc)
	c:SetCardTarget(sc)
	if tc:IsSetCard(0xaa5) and tc:GetControler()==tp then
		e:SetLabelObject(sc)
	end
	if sc:IsSetCard(0xaa5) and sc:GetControler()==tp then
		e:SetLabelObject(tc)
	end
end

function M.distg(e,c)
	return e:GetHandler():IsHasCardTarget(c) and not (c:IsSetCard(0xaa5) and c:GetControler()==e:GetHandler():GetControler())
end

function M.atkval(e,c)
	local tc=e:GetLabelObject():GetLabelObject()
	if not tc or not e:GetHandler():IsHasCardTarget(tc) then return 0 end
	if e:GetHandler():IsHasCardTarget(c) and c:IsSetCard(0xaa5) and c:GetControler()==e:GetHandler():GetControler() then
		return math.min(tc:GetAttack()/2, 1000)
	end
	return 0
end

function M.defval(e,c)
	local tc=e:GetLabelObject():GetLabelObject()
	if not tc or not e:GetHandler():IsHasCardTarget(tc) then return 0 end
	if e:GetHandler():IsHasCardTarget(c) and c:IsSetCard(0xaa5) and c:GetControler()==e:GetHandler():GetControler() then
		return math.min(tc:GetDefence()/2, 1000)
	end
	return 0
end

function M.descon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCardTargetCount()==0 then return false end
	local g=c:GetCardTarget()
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return eg:IsContains(tc1) or (tc2 and eg:IsContains(tc2))
end

function M.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

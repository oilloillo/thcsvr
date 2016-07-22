--三种神器　电冰箱
function c999208.initial_effect(c)
	--pend
	aux.EnablePendulumAttribute(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--get material
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(999208,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c999208.mattg)
	e1:SetOperation(c999208.matop)
	c:RegisterEffect(e1)
	--gain
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(999208,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c999208.gaincost)
	e2:SetTarget(c999208.gaintg)
	e2:SetOperation(c999208.gainop)
	c:RegisterEffect(e2)
	--replace material
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999208,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c999208.rcon)
	e3:SetOperation(c999208.rop)
	c:RegisterEffect(e3)
end

c999208.pendulum_level=4

function c999208.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE, tp, 0, LOCATION_DECK, nil)>0 end
end

function c999208.matop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(aux.TRUE, tp, 0, LOCATION_DECK, nil)==0 then return end
	local c=e:GetHandler()
	local sg=Duel.GetDecktopGroup(1-tp,1)
	Duel.Overlay(c,sg)
end

function c999208.gaincost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp, 500) end
	Duel.PayLPCost(tp, 500)
end

function c999208.gaintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local mg = c:GetOverlayGroup()
	if mg:GetCount()<1 then return end
	if chk==0 then return mg:IsExists(Card.IsAbleToHand, 1, nil) end
end

function c999208.gainop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local mg = c:GetOverlayGroup()
	if mg:GetCount()<1 then return end
	local sg = mg:FilterSelect(tp, Card.IsAbleToHand, 1, 1, nil)
	Duel.SendtoHand(sg, tp, REASON_EFFECT)
	Duel.ConfirmCards(1-tp, sg)
end

function c999208.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:GetHandler():IsType(TYPE_XYZ)
		and ep==e:GetOwnerPlayer() and e:GetHandler():GetOverlayCount()>0 and re:GetHandler():GetOverlayCount()>=bit.band(ev,0xffff)-1
end

function c999208.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	if ct==1 then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	else
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
end
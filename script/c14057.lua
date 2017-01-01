--梦幻馆的梦现✿风见幽香
function c14057.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c14057.xyzcon)
	e1:SetTarget(c14057.xyztg)
	e1:SetOperation(c14057.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--mamo
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(c14057.efilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c14057.bfilter)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14057,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c14057.thcost)
	e1:SetTarget(c14057.thtg)
	e1:SetOperation(c14057.thop)
	c:RegisterEffect(e1)
end
function c14057.cfilter(c)
	return c:IsSetCard(0x138) and c:IsType(TYPE_MONSTER)
end
function c14057.ovfilter(c,tp,xyzc)
	local cy=Duel.GetMatchingGroup(c14057.cfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x138) and c:IsCanBeXyzMaterial(xyzc)
		and c:CheckRemoveOverlayCard(tp,1,REASON_COST) and cy>3
end
function c14057.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 2<=ct then return false end
	if min and (min>2 or max<2) then return false end
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	if ct<1 and (not min or min<=1) and mg:IsExists(c14057.ovfilter,1,nil,tp,c) then
		return true
	end
	return Duel.CheckXyzMaterial(c,nil,10,2,2,og)
end
function c14057.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		return true
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	local b1=Duel.CheckXyzMaterial(c,nil,10,2,2,og)
	local b2=ct<1 and (not min or min<=1) and mg:IsExists(c14057.ovfilter,1,nil,tp,c)
	local g=nil
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(14057,0))) then
		e:SetLabel(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c14057.ovfilter,1,1,nil,tp,c)
		g:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		e:SetLabel(0)
		g=Duel.SelectXyzMaterial(tp,c,nil,10,2,2,og)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c14057.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		if e:GetLabel()==1 then
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
function c14057.efilter(e,c)
	return c:IsSetCard(0x138) and c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c14057.bfilter(e,c)
	return c:IsSetCard(0x138)
end
function c14057.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c14057.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackPos()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c14057.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetPosition()==POS_FACEUP_DEFENSE then return end
	Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

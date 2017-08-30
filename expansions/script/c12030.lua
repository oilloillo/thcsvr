--暗影翼之魔法使✿雾雨魔理沙
function c12030.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Nef.AddXyzProcedureWithDesc(c,nil,2,2,aux.Stringid(12030,0))
	-- xyzop
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12030,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c12030.xyzcon)
	e1:SetOperation(c12030.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c12030.atkval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12030,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c12030.descost)
	e3:SetTarget(c12030.destg)
	e3:SetOperation(c12030.desop)
	c:RegisterEffect(e3)
end
function c12030.hofilter(c, tp, xyzc, lv)
	if c:IsType(TYPE_TOKEN) or not c:IsCanBeXyzMaterial(xyzc) then return false end
	return c:IsSetCard(0x208) and c:IsFaceup() and c:IsLevelBelow(3)
end
function c12030.rfilter3(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
end
function c12030.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c12030.hofilter, tp, LOCATION_MZONE, 0, 1, nil, tp, c)
		and Duel.IsExistingMatchingCard(c12030.rfilter3, tp, LOCATION_GRAVE, 0, 2, nil)
end
function c12030.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local rm = Duel.SelectMatchingCard(tp, c12030.rfilter3, tp, LOCATION_GRAVE, 0, 2, 2, nil, tp, c)
	if rm:GetCount()<2 then return end
	local mg = Duel.SelectMatchingCard(tp, c12030.hofilter, tp, LOCATION_MZONE, 0, 1, 1, nil, tp, c)
	if mg:GetCount()<1 then return end
	Duel.Remove(rm,POS_FACEUP,REASON_COST)
	c:SetMaterial(mg)
	Duel.Overlay(c, mg)
end
function c12030.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c12030.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12030.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*300
end
function c12030.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c12030.dsfilter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c12030.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c12030.dsfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12030.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12030.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c12030.limit(g:GetFirst()))
end
function c12030.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler() ~= c
			end
end
function c12030.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
